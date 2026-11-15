import 'package:shared_preferences/shared_preferences.dart';

import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/features/planner/domain/priority.dart';

/// The last-used form values, restored on launch.
class StoredInputs {
  const StoredInputs({
    required this.latitudeText,
    required this.longitudeText,
    required this.areaText,
    required this.ph,
    required this.phAssumed,
    required this.priorities,
  });

  final String latitudeText;
  final String longitudeText;
  final String areaText;
  final double ph;
  final bool phAssumed;
  final Set<Priority> priorities;
}

class InputStorage {
  InputStorage({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  static const String _latitude = 'planner.latitude';
  static const String _longitude = 'planner.longitude';
  static const String _area = 'planner.area';
  static const String _ph = 'planner.ph';
  static const String _phAssumed = 'planner.phAssumed';
  static const String _priorities = 'planner.priorities';

  Future<StoredInputs?> read() async {
    try {
      if (!await _preferences.containsKey(_ph)) return null;
      final names = await _preferences.getStringList(_priorities) ?? const <String>[];
      return StoredInputs(
        latitudeText: await _preferences.getString(_latitude) ?? '',
        longitudeText: await _preferences.getString(_longitude) ?? '',
        areaText: await _preferences.getString(_area) ?? '',
        ph: await _preferences.getDouble(_ph) ?? InputLimits.defaultPh,
        phAssumed: await _preferences.getBool(_phAssumed) ?? false,
        priorities: {
          for (final priority in Priority.values)
            if (names.contains(priority.name)) priority,
        },
      );
    } on Exception {
      return null;
    }
  }

  Future<void> write(StoredInputs inputs) async {
    try {
      await Future.wait([
        _preferences.setString(_latitude, inputs.latitudeText),
        _preferences.setString(_longitude, inputs.longitudeText),
        _preferences.setString(_area, inputs.areaText),
        _preferences.setDouble(_ph, inputs.ph),
        _preferences.setBool(_phAssumed, inputs.phAssumed),
        _preferences.setStringList(_priorities, [for (final p in inputs.priorities) p.name]),
      ]);
    } on Exception {
      // Best effort: losing a saved draft never blocks planning.
    }
  }
}
