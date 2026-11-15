import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/app.dart';
import 'package:nabta/features/planner/data/input_storage.dart';
import 'package:nabta/features/planner/data/local_rotation_repository.dart';
import 'package:nabta/features/planner/data/location_service.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/settings/settings_controller.dart';
import 'package:nabta/features/settings/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsController(SettingsRepository());
  final planner = PlannerController(
    repository: LocalRotationRepository(),
    storage: InputStorage(),
  );

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
