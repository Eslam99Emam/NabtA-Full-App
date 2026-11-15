import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/widgets/app_input_decoration.dart';
import 'package:nabta/features/planner/presentation/planner_controller.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Latitude and longitude fields kept in two-way sync with the pin.
/// Pasting "30.0444, 31.2357" into either one fills both.
class CoordinateFields extends StatefulWidget {
  const CoordinateFields({super.key});

  @override
  State<CoordinateFields> createState() => _CoordinateFieldsState();
}

class _CoordinateFieldsState extends State<CoordinateFields> {
  late final PlannerController _planner;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;

  @override
  void initState() {
    super.initState();
    _planner = context.read<PlannerController>();
    _latitude = TextEditingController(text: _planner.latitudeText);
    _longitude = TextEditingController(text: _planner.longitudeText);
    _planner.addListener(_syncFromPlanner);
  }

  void _syncFromPlanner() {
    _apply(_latitude, _planner.latitudeText);
    _apply(_longitude, _planner.longitudeText);
  }

  static void _apply(TextEditingController controller, String text) {
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void dispose() {
    _planner.removeListener(_syncFromPlanner);
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final validation = context.watch<PlannerController>().visibleValidation;

    final latitudeField = _field(
      controller: _latitude,
      label: l10n.latitudeLabel,
      error: validationMessage(l10n, format, validation.latitude),
      onChanged: _planner.setLatitudeText,
    );
    final longitudeField = _field(
      controller: _longitude,
      label: l10n.longitudeLabel,
      error: validationMessage(l10n, format, validation.longitude),
      onChanged: _planner.setLongitudeText,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final roomy = constraints.maxWidth >= 360 &&
            MediaQuery.textScalerOf(context).scale(16) <= 24;
        if (roomy) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: latitudeField),
              const SizedBox(width: Space.m - Space.half),
              Expanded(child: longitudeField),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [latitudeField, const SizedBox(height: Space.m - Space.half), longitudeField],
        );
      },
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? error,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: appInputDecoration(context, label: label, errorText: error),
    );
  }
}
