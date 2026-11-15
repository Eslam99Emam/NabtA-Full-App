# -*- coding: utf-8 -*-
import json
from enum import Enum
from typing import Optional

from fastapi import FastAPI, HTTPException, Response
from pydantic import BaseModel, Field

import pipelines

app = FastAPI(title="Crop Recommendation API")


class Priority(str, Enum):
    water_conserving = "water_conserving"
    market_suitability = "market_suitability"
    nitrogen_fixing = "nitrogen_fixing"


class RecommendRequest(BaseModel):
    lat: float = Field(ge=-90, le=90)
    lon: float = Field(ge=-180, le=180)
    area_hectares: float = Field(
        gt=0, description="Land area in hectares (1 feddan is about 0.42 ha)"
    )
    soil_ph: float = Field(ge=0, le=14)
    priority: Priority


class CropResult(BaseModel):
    ScientificName: str
    FAMNAME: Optional[str] = None
    COMNAME: Optional[str] = None
    LISPA: Optional[str] = None
    CAT: Optional[str] = None
    TOPMN: Optional[float] = None
    TOPMX: Optional[float] = None
    TMIN: Optional[float] = None
    TMAX: Optional[float] = None
    ROPMN: Optional[float] = None
    ROPMX: Optional[float] = None
    RMIN: Optional[float] = None
    RMAX: Optional[float] = None
    PHOPMN: Optional[float] = None
    PHOPMX: Optional[float] = None
    PHMIN: Optional[float] = None
    PHMAX: Optional[float] = None
    DEP: Optional[str] = None
    DEPR: Optional[str] = None
    TEXT: Optional[str] = None
    TEXTR: Optional[str] = None
    SAL: Optional[str] = None
    SALR: Optional[str] = None
    DRA: Optional[str] = None
    DRAR: Optional[str] = None
    ALTMX: Optional[float] = None
    LIOPMN: Optional[str] = None
    LIOPMX: Optional[str] = None
    LIMN: Optional[str] = None
    LIMX: Optional[str] = None
    PHOTO: Optional[str] = None
    GMIN: Optional[float] = None
    GMAX: Optional[float] = None
    # scores, all 0-1, higher is better
    crop_to_soil_compatibility: float
    market_suitability_score: float
    nitrogen_fixing_score: float
    water_use_score: float
    overall_score: float


@app.post("/recommend", response_model=list[CropResult])
def recommend(req: RecommendRequest, response: Response):
    # Plain `def` so FastAPI runs the blocking Earth Engine calls in a worker thread.
    try:
        print("Starting ")
        result, farm, warnings = pipelines.recommend(
            lat=req.lat,
            lon=req.lon,
            area_ha=req.area_hectares,
            soil_ph=req.soil_ph,
            priority=req.priority.value,
            top_n=3,
        )
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:  # Earth Engine auth / quota / network errors
        raise HTTPException(status_code=502, detail=f"Earth Engine request failed: {e}")

    if warnings:
        response.headers["X-Data-Warnings"] = " | ".join(warnings)
    return json.loads(result.to_json(orient="records"))
