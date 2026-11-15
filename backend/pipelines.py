# -*- coding: utf-8 -*-
"""
Crop-scoring pipelines, adapted from temp_pipeline.py, soil_pipeline.py and
final_score.py so they can run per request instead of as Colab notebooks.

Earth Engine is imported lazily so the pure scoring functions can be used and
tested without `ee` installed.
"""

import math
import os
from functools import lru_cache
from pathlib import Path

import numpy as np
import pandas as pd

BASE_DIR = Path(__file__).parent
CROPS_CSV = BASE_DIR / "final_df.csv"
MARKET_CSV = BASE_DIR / "market_suitability_score.csv"
GEE_PROJECT = os.environ.get("GEE_PROJECT", "nasa-agricultural-project")

CROP_COLUMNS = [
    "ScientificName",
    "FAMNAME",
    "COMNAME",
    "LISPA",
    "CAT",
    "TOPMN",
    "TOPMX",
    "TMIN",
    "TMAX",
    "ROPMN",
    "ROPMX",
    "RMIN",
    "RMAX",
    "PHOPMN",
    "PHOPMX",
    "PHMIN",
    "PHMAX",
    "DEP",
    "DEPR",
    "TEXT",
    "TEXTR",
    "SAL",
    "SALR",
    "DRA",
    "DRAR",
    "ALTMX",
    "LIOPMN",
    "LIOPMX",
    "LIMN",
    "LIMX",
    "PHOTO",
    "GMIN",
    "GMAX",
]


# ---------------------------------------------------------------------------
# Data loading
# ---------------------------------------------------------------------------
@lru_cache(maxsize=1)
def load_crops() -> pd.DataFrame:
    df = pd.read_csv(CROPS_CSV)
    df = df[CROP_COLUMNS].copy()  # drops the unnamed index column

    # final_df.csv has Cynara cardunculus with GMIN=1500 > GMAX=300; swap so the
    # minimum is never larger than the maximum.
    lo = df[["GMIN", "GMAX"]].min(axis=1)
    hi = df[["GMIN", "GMAX"]].max(axis=1)
    df["GMIN"], df["GMAX"] = lo, hi
    return df


@lru_cache(maxsize=1)
def load_market() -> pd.DataFrame:
    """
    Returns a frame with columns ScientificName, market_suitability_score (0-1).

    ASSUMPTION: market_suitability_score.csv has a ScientificName column and one
    numeric score column. If the scores are on a 0-100 scale they are divided by 100.
    """
    m = pd.read_csv(MARKET_CSV)
    score_cols = [
        c
        for c in m.columns
        if c != "ScientificName" and pd.api.types.is_numeric_dtype(m[c])
    ]
    preferred = [c for c in score_cols if "market" in c.lower() or "score" in c.lower()]
    col = (preferred or score_cols)[0]
    out = m[["ScientificName", col]].rename(columns={col: "market_suitability_score"})
    if out["market_suitability_score"].max() > 1:
        out["market_suitability_score"] = out["market_suitability_score"] / 100.0
    return out


# ---------------------------------------------------------------------------
# Earth Engine
# ---------------------------------------------------------------------------
_ee_ready = False


def init_ee() -> None:
    """Initialise Earth Engine once (non-interactive, safe for a server)."""
    global _ee_ready
    if _ee_ready:
        return
    import ee

    key_file = os.environ.get("GEE_SERVICE_ACCOUNT_KEY")  # optional JSON key path
    if key_file:
        import json

        email = json.load(open(key_file))["client_email"]
        ee.Initialize(
            ee.ServiceAccountCredentials(email, key_file), project=GEE_PROJECT
        )
    else:
        ee.Initialize(project=GEE_PROJECT)  # needs `earthengine authenticate` done once
    _ee_ready = True


def square_polygon(lat: float, lon: float, side_m: float) -> list:
    """Square ring (list of [lon, lat]) of the given side length centred on a point."""
    half_lat = (side_m / 2) / 111_320.0
    half_lon = (side_m / 2) / (111_320.0 * max(math.cos(math.radians(lat)), 0.01))
    return [
        [
            [lon - half_lon, lat - half_lat],
            [lon + half_lon, lat - half_lat],
            [lon + half_lon, lat + half_lat],
            [lon - half_lon, lat + half_lat],
        ]
    ]


def fetch_monthly_temperature(lat: float, lon: float) -> pd.DataFrame:
    """Monthly mean temperature (deg C) from ERA5-Land. Same logic as temp_pipeline.py."""
    import ee

    init_ee()
    # ERA5-Land is ~11 km, so a fixed ~5 km box around the point is equivalent
    # to your sample polygon and avoids empty reductions for tiny farms.
    polygon = ee.Geometry.Polygon(square_polygon(lat, lon, 5000))
    collection = (
        ee.ImageCollection("ECMWF/ERA5_LAND/DAILY_AGGR")
        .filterBounds(polygon)
        .filterDate("2025-01-01", "2026-01-01")  # end date is exclusive
    )

    def extract(image):
        stats = image.select(["temperature_2m"]).reduceRegion(
            reducer=ee.Reducer.mean(), geometry=polygon, scale=11132, maxPixels=1e9
        )
        date = ee.Date(image.get("system:time_start")).format("YYYY-MM-dd")
        return ee.Feature(
            None, {"date": date, "temperature_2m": stats.get("temperature_2m")}
        )

    features = collection.map(extract).getInfo()["features"]
    df = pd.DataFrame(
        [
            {
                "date": f["properties"]["date"],
                "k": f["properties"].get("temperature_2m"),
            }
            for f in features
        ]
    ).dropna()
    df["temperature_2m_c"] = df["k"] - 273.15
    df["date"] = pd.to_datetime(df["date"])
    return (
        df.groupby(df["date"].dt.to_period("M"))["temperature_2m_c"]
        .mean()
        .reset_index()
    )


def map_texture(b0_value) -> str:
    # OpenLandMap USDA classes: 1-3 are clays, 4-7 loams, 8-12 silt/sandy classes.
    cls = round(b0_value)
    if cls in (1, 2, 3):
        return "heavy"
    if cls in (4, 5, 6, 7):
        return "medium"
    if cls in (8, 9, 10, 11, 12):
        return "light"
    return "medium"


def map_drainage(vwc_value) -> str:
    if vwc_value < 0.20:
        return "excessive (dry/moderately dry)"
    if vwc_value <= 0.40:
        return "well (dry spells)"
    return "poorly (saturated >50% of year)"


def map_salinity(sal_value) -> str:
    if sal_value < 4:
        return "low (<4 dS/m)"
    if sal_value <= 10:
        return "medium (4-10 dS/m)"
    return "high (>10 dS/m)"


def fetch_farm_soil_profile(polygon_ring: list) -> tuple[dict, list]:
    """
    Same extraction as soil_pipeline.py. Returns (farm_conditions, warnings).
    Missing salinity falls back to 'low'; missing texture/drainage raises ValueError.
    """
    import ee

    init_ee()
    farm_polygon = ee.Geometry.Polygon(polygon_ring)
    warnings = []

    texture_image = ee.Image("OpenLandMap/SOL/SOL_TEXTURE-CLASS_USDA-TT_M/v02").select(
        "b0"
    )
    water_image = ee.Image("ISRIC/SoilGrids250m/v2_0/wv0033").select("val_0_5cm_mean")

    texture = texture_image.reduceRegion(
        reducer=ee.Reducer.mode(), geometry=farm_polygon, scale=250, maxPixels=1e9
    ).get("b0")
    water = water_image.reduceRegion(
        reducer=ee.Reducer.mean(), geometry=farm_polygon, scale=250, maxPixels=1e9
    ).get("val_0_5cm_mean")
    basic = ee.Dictionary({"texture": texture, "water": water}).getInfo()

    if basic.get("texture") is None or basic.get("water") is None:
        raise ValueError("No soil texture/water data available for this location.")

    salinity_val = None
    try:
        salinity_collection = ee.ImageCollection(
            "projects/sat-io/open-datasets/global_soil_salinity"
        ).filterBounds(farm_polygon)
        sal_stats = salinity_collection.mean().reduceRegion(
            reducer=ee.Reducer.mean(), geometry=farm_polygon, scale=30, maxPixels=1e9
        )
        salinity_val = (
            ee.Dictionary({"s": sal_stats.values().get(0)}).getInfo().get("s")
        )
    except ee.EEException:
        salinity_val = None

    if salinity_val is None:
        warnings.append("No salinity data for this location; assumed low salinity.")
        salinity = "low (<4 dS/m)"
    else:
        salinity = map_salinity(salinity_val)

    farm = {
        "texture": map_texture(basic["texture"]),
        "drainage": map_drainage(basic["water"]),
        "salinity": salinity,
    }
    return farm, warnings


# ---------------------------------------------------------------------------
# Temperature score (temp_pipeline.py)
# ---------------------------------------------------------------------------
def temp_month_score(t, topmn, topmx, tmin, tmax) -> float:
    if topmn <= t <= topmx:
        return 1.0
    if tmin < t < topmn:
        return (t - tmin) / (topmn - tmin)
    if topmx < t < tmax:
        return (tmax - t) / (tmax - topmx)
    return 0.0  # outside the survivable range


def temp_scores(crops: pd.DataFrame, temp_monthly: pd.DataFrame) -> pd.Series:
    """Best growing window (circular over the year) of ceil(GMIN/30) months, mean monthly score."""
    temps = list(temp_monthly["temperature_2m_c"])
    n = len(temps)
    out = []
    for c in crops.itertuples(index=False):
        rates = [temp_month_score(t, c.TOPMN, c.TOPMX, c.TMIN, c.TMAX) for t in temps]
        duration = max(1, min(math.ceil(c.GMIN / 30), 12, n))
        best = max(
            float(np.mean([rates[(s + k) % n] for k in range(duration)]))
            for s in range(n)
        )
        out.append(best)
    return pd.Series(out, index=crops.index)


# ---------------------------------------------------------------------------
# Soil score (soil_pipeline.py) + pH
# ---------------------------------------------------------------------------
def soil_scores(crops: pd.DataFrame, farm: dict) -> pd.DataFrame:
    def match(farm_value, crop_text):
        text = str(crop_text)
        return int(farm_value in text or "wide" in text)

    return pd.DataFrame(
        {
            "texture": [match(farm["texture"], t) for t in crops["TEXT"]],
            "salinity": [match(farm["salinity"], s) for s in crops["SAL"]],
            "drainage": [match(farm["drainage"], d) for d in crops["DRA"]],
        },
        index=crops.index,
    )


def ph_scores(crops: pd.DataFrame, ph: float) -> pd.Series:
    def one(c):
        if c.PHOPMN <= ph <= c.PHOPMX:
            return 1.0
        if c.PHMIN < ph < c.PHOPMN:
            return (ph - c.PHMIN) / (c.PHOPMN - c.PHMIN)
        if c.PHOPMX < ph < c.PHMAX:
            return (c.PHMAX - ph) / (c.PHMAX - c.PHOPMX)
        return 0.0

    return pd.Series([one(c) for c in crops.itertuples(index=False)], index=crops.index)


def crop_to_soil_compatibility(temp, soil: pd.DataFrame, ph) -> pd.Series:
    """final_score.py's sum (temp + texture + salinity + drainage) plus pH, scaled to 0-1."""
    total = temp + soil["texture"] + soil["salinity"] + soil["drainage"] + ph
    return total / 5.0


# ---------------------------------------------------------------------------
# Farmer-priority scores (all 0-1, higher = better)
# ---------------------------------------------------------------------------
_DEPTH_FACTOR = {"deep": 1.0, "medium": 0.7, "shallow": 0.4}


def nitrogen_fixing_scores(crops: pd.DataFrame) -> pd.Series:
    """
    Invented heuristic, 0-1:
      * only legumes (Leguminosae) fix nitrogen, every other family scores 0
      * duration  = clip((mean(GMIN, GMAX) - 20) / 160, 0, 1)   (fixation starts after nodulation,
                    ~3 weeks, and saturates at a 180-day cycle)
      * depth     = deep 1.0 / medium 0.7 / shallow 0.4 (from DEP, deeper rooting = more nodulated root volume)
      * score     = 0.6 * duration + 0.4 * depth
    """
    out = []
    for c in crops.itertuples(index=False):
        if "Leguminosae" not in str(c.FAMNAME) and "Fabaceae" not in str(c.FAMNAME):
            out.append(0.0)
            continue
        mean_days = (c.GMIN + c.GMAX) / 2
        duration = float(np.clip((mean_days - 20) / 160, 0, 1))
        depth = _DEPTH_FACTOR.get(str(c.DEP).split(" ")[0], 0.7)
        out.append(0.6 * duration + 0.4 * depth)
    return pd.Series(out, index=crops.index)


def water_use_scores(crops: pd.DataFrame) -> pd.Series:
    """
    Water need = mean(ROPMN, ROPMX), placed as a fraction between the lowest and highest need
    in the whole table. The score is inverted so 1.0 = most water-conserving crop.
    """
    need = (crops["ROPMN"] + crops["ROPMX"]) / 2
    frac = (need - need.min()) / (need.max() - need.min())
    return 1.0 - frac


# ---------------------------------------------------------------------------
# Orchestration
# ---------------------------------------------------------------------------
PRIORITY_COLUMN = {
    "water_conserving": "water_use_score",
    "market_suitability": "market_suitability_score",
    "nitrogen_fixing": "nitrogen_fixing_score",
}


def recommend(
    lat: float,
    lon: float,
    area_ha: float,
    soil_ph: float,
    priority: str,
    top_n: int = 3,
):
    crops = load_crops()

    # Farm polygon from point + area (square). Minimum 250 m side = one SoilGrids pixel.
    side_m = max(math.sqrt(area_ha * 10_000), 250.0)
    ring = square_polygon(lat, lon, side_m)

    temp_monthly = fetch_monthly_temperature(lat, lon)
    farm, warnings = fetch_farm_soil_profile(ring)

    temp = temp_scores(crops, temp_monthly)
    soil = soil_scores(crops, farm)
    ph = ph_scores(crops, soil_ph)

    result = crops.copy()
    result["crop_to_soil_compatibility"] = crop_to_soil_compatibility(temp, soil, ph)
    result["nitrogen_fixing_score"] = nitrogen_fixing_scores(crops)
    result["water_use_score"] = water_use_scores(crops)

    market = load_market()
    result = result.merge(market, on="ScientificName", how="left")
    print(result)
    if result["market_suitability_score"].isna().any():
        warnings.append("Some crops have no market score; treated as 0.")
        result["market_suitability_score"] = result["market_suitability_score"].fillna(
            0.0
        )

    priority_col = PRIORITY_COLUMN[priority]
    result["overall_score"] = (
        result["crop_to_soil_compatibility"] * result[priority_col]
    )
    result = result.sort_values(
        by=["overall_score", "crop_to_soil_compatibility", priority_col],
        ascending=False,
    ).head(top_n)
    return result, farm, warnings
