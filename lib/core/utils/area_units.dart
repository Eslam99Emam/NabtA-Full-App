/// Area conversions from square meters.
abstract final class AreaUnits {
  static const double m2PerHectare = 10000;
  static const double m2PerAcre = 4046.8564224;
  static const double m2PerFeddan = 4200.83;

  static double hectares(double m2) => m2 / m2PerHectare;
  static double acres(double m2) => m2 / m2PerAcre;
  static double feddans(double m2) => m2 / m2PerFeddan;
}
