import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/utils/number_input.dart';
import 'package:nabta/core/widgets/app_input_decoration.dart';
import 'package:nabta/features/planner/domain/input_validation.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Lets the grower type a pH value. Returns null when cancelled.
Future<double?> showPhDialog(BuildContext context, {required double initial}) {
  return showDialog<double>(
    context: context,
    builder: (_) => PhDialog(initial: initial),
  );
}

class PhDialog extends StatefulWidget {
  const PhDialog({super.key, required this.initial});

  final double initial;

  @override
  State<PhDialog> createState() => _PhDialogState();
}

class _PhDialogState extends State<PhDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial.toStringAsFixed(1));
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final value = NumberInput.parse(_controller.text);
    if (value == null || value < InputLimits.minPh || value > InputLimits.maxPh) {
      setState(() {
        _error = l10n.phDialogError(
          format.decimal(InputLimits.minPh),
          format.decimal(InputLimits.maxPh),
        );
      });
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    return AlertDialog(
      scrollable: true,
      title: Text(l10n.phDialogTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        style: Theme.of(context).textTheme.titleLarge,
        decoration: appInputDecoration(
          context,
          label: l10n.phTitle,
          helperText: l10n.phDialogHint(
            format.decimal(InputLimits.minPh),
            format.decimal(InputLimits.maxPh),
          ),
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
