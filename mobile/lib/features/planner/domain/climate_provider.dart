import 'package:nabta/features/planner/domain/season.dart';

/// Supplies a mean air temperature for a growing window.
/// Swap in a data-backed implementation (e.g. NASA POWER) later.
abstract interface class ClimateProvider {
  double meanTemperatureC({required double latitude, required SeasonKind season});
}

/// Rough zonal climate model based only on latitude.
///
/// * Annual mean ≈ 27 − 0.0067 · lat² °C. That gives about 27 °C at the
///   equator, 21 °C at 30°, 16 °C at 40° and 3 °C at 60°.
/// * The warm and cool windows sit ± 0.15 · |lat| °C around that mean, so
///   the seasonal swing grows away from the tropics.
///
/// It ignores altitude, oceans and continentality. It is fine for ranking
/// crops but is not a forecast.
class LatitudeClimateProvider implements ClimateProvider {
  const LatitudeClimateProvider();

  @override
  double meanTemperatureC({required double latitude, required SeasonKind season}) {
    final absLatitude = latitude.abs();
    final annualMean = 27 - 0.0067 * absLatitude * absLatitude;
    final swing = 0.15 * absLatitude;
    return season == SeasonKind.warm ? annualMean + swing : annualMean - swing;
  }
}
