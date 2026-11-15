import 'package:nabta/core/utils/number_input.dart';
import 'package:nabta/features/planner/domain/priority.dart';

enum ValidationIssue {
  locationMissing,
  latitudeNotNumber,
  latitudeOutOfRange,
  longitudeNotNumber,
  longitudeOutOfRange,
  areaMissing,
  areaNotNumber,
  areaOutOfRange,
  prioritiesEmpty,
}

/// The four input cards, in screen order.
enum InputStep { location, area, ph, priorities }

abstract final class InputLimits {
  static const double minLatitude = -90;
  static const double maxLatitude = 90;
  static const double minLongitude = -180;
  static const double maxLongitude = 180;
  static const double maxAreaM2 = 100000000;
  static const double minPh = 3.5;
  static const double maxPh = 9.5;
  static const double defaultPh = 6.5;
  static const double neutralPh = 7;
  static const double phStep = 0.1;
  static const double acidicTipBelow = 5.5;
  static const double alkalineTipAbove = 8.0;
  static const List<int> quickAreasM2 = [500, 1000, 5000, 10000];
}

class InputValidation {
  const InputValidation({
    this.location,
    this.latitude,
    this.longitude,
    this.area,
    this.priorities,
  });

  final ValidationIssue? location;
  final ValidationIssue? latitude;
  final ValidationIssue? longitude;
  final ValidationIssue? area;
  final ValidationIssue? priorities;

  bool get isValid => invalidSteps.isEmpty;

  Set<InputStep> get invalidSteps => {
        if (location != null || latitude != null || longitude != null) InputStep.location,
        if (area != null) InputStep.area,
        if (priorities != null) InputStep.priorities,
      };

  InputStep? get firstInvalidStep {
    final invalid = invalidSteps;
    for (final step in InputStep.values) {
      if (invalid.contains(step)) return step;
    }
    return null;
  }
}

abstract final class InputValidator {
  static InputValidation validate({
    required String latitudeText,
    required String longitudeText,
    required String areaText,
    required Set<Priority> priorities,
  }) {
    final bothBlank = latitudeText.trim().isEmpty && longitudeText.trim().isEmpty;
    return InputValidation(
      location: bothBlank ? ValidationIssue.locationMissing : null,
      latitude: bothBlank
          ? null
          : _coordinateIssue(
              latitudeText,
              min: InputLimits.minLatitude,
              max: InputLimits.maxLatitude,
              notNumber: ValidationIssue.latitudeNotNumber,
              outOfRange: ValidationIssue.latitudeOutOfRange,
            ),
      longitude: bothBlank
          ? null
          : _coordinateIssue(
              longitudeText,
              min: InputLimits.minLongitude,
              max: InputLimits.maxLongitude,
              notNumber: ValidationIssue.longitudeNotNumber,
              outOfRange: ValidationIssue.longitudeOutOfRange,
            ),
      area: _areaIssue(areaText),
      priorities: priorities.isEmpty ? ValidationIssue.prioritiesEmpty : null,
    );
  }

  static ({double latitude, double longitude})? parseLocation(String latitudeText, String longitudeText) {
    final latitude = NumberInput.parse(latitudeText);
    final longitude = NumberInput.parse(longitudeText);
    if (latitude == null || longitude == null) return null;
    if (latitude < InputLimits.minLatitude || latitude > InputLimits.maxLatitude) return null;
    if (longitude < InputLimits.minLongitude || longitude > InputLimits.maxLongitude) return null;
    return (latitude: latitude, longitude: longitude);
  }

  static double? parseArea(String text) => NumberInput.parse(text, allowGrouping: true);

  static ValidationIssue? _coordinateIssue(
    String text, {
    required double min,
    required double max,
    required ValidationIssue notNumber,
    required ValidationIssue outOfRange,
  }) {
    final value = NumberInput.parse(text);
    if (value == null) return notNumber;
    if (value < min || value > max) return outOfRange;
    return null;
  }

  static ValidationIssue? _areaIssue(String text) {
    if (text.trim().isEmpty) return ValidationIssue.areaMissing;
    final value = parseArea(text);
    if (value == null) return ValidationIssue.areaNotNumber;
    if (value <= 0 || value > InputLimits.maxAreaM2) return ValidationIssue.areaOutOfRange;
    return null;
  }
}
