import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';

/// Shared text-field look: filled, radius 16, generous padding, roomy
/// helper/error lines that wrap instead of clipping at large text sizes.
InputDecoration appInputDecoration(
  BuildContext context, {
  required String label,
  String? helperText,
  String? errorText,
  String? suffixText,
  Widget? prefixIcon,
}) {
  final scheme = Theme.of(context).colorScheme;

  OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(Radii.input),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    labelText: label,
    helperText: helperText,
    helperMaxLines: 3,
    errorText: errorText,
    errorMaxLines: 3,
    suffixText: suffixText,
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: scheme.surfaceContainerLowest,
    contentPadding: const EdgeInsetsDirectional.fromSTEB(Space.m, Space.m + 2, Space.m, Space.m + 2),
    border: border(scheme.outline, 1),
    enabledBorder: border(scheme.outline, 1),
    focusedBorder: border(scheme.primary, 2),
    errorBorder: border(scheme.error, 1.5),
    focusedErrorBorder: border(scheme.error, 2),
  );
}
