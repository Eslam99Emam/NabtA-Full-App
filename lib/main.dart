import 'dart:developer';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/app.dart';
import 'package:nabta/features/planner/data/input_storage.dart';
import 'package:nabta/features/planner/data/location_service.dart';
import 'package:nabta/features/planner/data/remote_rotation_repository.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/settings/settings_controller.dart';
import 'package:nabta/features/settings/settings_repository.dart';

/// Override per run: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000`
/// (10.0.2.2 is how the Android emulator reaches your computer's localhost).
const String _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsController(SettingsRepository());
  final planner = PlannerController(
    repository: RemoteRotationRepository(baseUrl: _apiBaseUrl),
    storage: InputStorage(),
  );
  log(_apiBaseUrl);

  await Future.wait([
    settings.load(
      deviceLanguageCode:
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
    ),
    planner.restoreInputs(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(value: settings),
        ChangeNotifierProvider<PlannerController>.value(value: planner),
        Provider<LocationService>.value(value: const LocationService()),
      ],
      child: const NabtaApp(),
    ),
  );
}
