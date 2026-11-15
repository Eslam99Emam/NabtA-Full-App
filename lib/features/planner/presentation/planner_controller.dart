import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'package:nabta/core/utils/number_input.dart';
import 'package:nabta/features/planner/data/input_storage.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/rotation_repository.dart';

enum PlannerStatus { idle, loading, success, error }

/// Holds the form, validates it, and loads rotation plans.
class PlannerController extends ChangeNotifier {
  // Private named parameters: callers still pass `repository:` / `storage:`.
  PlannerController({
    required this._repository,
    required this._storage,
  });

  final RotationRepository _repository;
  final InputStorage _storage;

  String _latitudeText = '';
  String _longitudeText = '';
  String _areaText = '';
  double _ph = InputLimits.defaultPh;
  bool _phAssumed = false;
  Set<Priority> _priorities = const {};
  bool _showErrors = false;

  PlannerStatus _status = PlannerStatus.idle;
  List<RotationStrategy> _strategies = const [];
  LandInput? _submittedInput;
  int _requestId = 0;

  String get latitudeText => _latitudeText;
  String get longitudeText => _longitudeText;
  String get areaText => _areaText;
  double get ph => _ph;
  bool get phAssumed => _phAssumed;
  Set<Priority> get priorities => _priorities;
  PlannerStatus get status => _status;
  List<RotationStrategy> get strategies => _strategies;
  LandInput? get submittedInput => _submittedInput;

  InputValidation get validation => InputValidator.validate(
        latitudeText: _latitudeText,
        longitudeText: _longitudeText,
        areaText: _areaText,
        priorities: _priorities,
      );

  /// Errors stay hidden until the first submit attempt.
  InputValidation get visibleValidation => _showErrors ? validation : const InputValidation();

  LatLng? get location {
    final parsed = InputValidator.parseLocation(_latitudeText, _longitudeText);
    return parsed == null ? null : LatLng(parsed.latitude, parsed.longitude);
  }

  double? get areaM2 => InputValidator.parseArea(_areaText);

  Future<void> restoreInputs() async {
    final stored = await _storage.read();
    if (stored == null) return;
    _latitudeText = stored.latitudeText;
    _longitudeText = stored.longitudeText;
    _areaText = stored.areaText;
    _ph = stored.ph.clamp(InputLimits.minPh, InputLimits.maxPh).toDouble();
    _phAssumed = stored.phAssumed;
    _priorities = Set.unmodifiable(stored.priorities);
    notifyListeners();
  }

  void setLatitudeText(String value) => _setCoordinateText(value, isLatitude: true);

  void setLongitudeText(String value) => _setCoordinateText(value, isLatitude: false);

  /// A pasted "lat, lng" pair in either field fills both.
  void _setCoordinateText(String value, {required bool isLatitude}) {
    final pair = NumberInput.parseCoordinatePair(value);
    if (pair != null) {
      _latitudeText = NumberInput.compact(pair.$1);
      _longitudeText = NumberInput.compact(pair.$2);
    } else if (isLatitude) {
      _latitudeText = value;
    } else {
      _longitudeText = value;
    }
    _changed();
  }

  void setLocation(LatLng point) {
    _latitudeText = point.latitude.toStringAsFixed(5);
    _longitudeText = point.longitude.toStringAsFixed(5);
    _changed();
  }

  void setAreaText(String value) {
    _areaText = value;
    _changed();
  }

  void setQuickArea(int squareMeters) {
    _areaText = squareMeters.toString();
    _changed();
  }

  void setPh(double value) {
    final clamped = value.clamp(InputLimits.minPh, InputLimits.maxPh).toDouble();
    _ph = NumberInput.roundTo(clamped, 1);
    _phAssumed = false;
    _changed();
  }

  void assumeUnknownPh() {
    _ph = InputLimits.defaultPh;
    _phAssumed = true;
    _changed();
  }

  void togglePriority(Priority priority) {
    final next = {..._priorities};
    if (!next.remove(priority)) next.add(priority);
    _priorities = Set.unmodifiable(next);
    _changed();
  }

  /// Validates and, when valid, starts loading. Returns whether it started.
  bool submit() {
    _showErrors = true;
    final point = location;
    final area = areaM2;
    if (!validation.isValid || point == null || area == null) {
      notifyListeners();
      return false;
    }
    _submittedInput = LandInput(
      latitude: point.latitude,
      longitude: point.longitude,
      areaM2: area,
      ph: _ph,
      phAssumed: _phAssumed,
      priorities: _priorities,
    );
    unawaited(_load());
    return true;
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    final input = _submittedInput;
    if (input == null) return;
    final requestId = ++_requestId;
    _status = PlannerStatus.loading;
    notifyListeners();
    try {
      final strategies = await _repository.recommend(input);
      if (requestId != _requestId) return;
      _strategies = strategies;
      _status = PlannerStatus.success;
    } catch (_) {
      if (requestId != _requestId) return;
      _status = PlannerStatus.error;
    }
    notifyListeners();
  }

  void _changed() {
    notifyListeners();
    unawaited(_storage.write(StoredInputs(
      latitudeText: _latitudeText,
      longitudeText: _longitudeText,
      areaText: _areaText,
      ph: _ph,
      phAssumed: _phAssumed,
      priorities: _priorities,
    )));
  }
}
