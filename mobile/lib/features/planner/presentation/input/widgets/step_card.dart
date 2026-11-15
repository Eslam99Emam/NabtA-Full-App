import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/app_format.dart';
import 'package:nabta/core/widgets/messages.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// A numbered input step: badge, title, one-line helper, content, and an
/// optional inline error. The outline turns red when the step is invalid.
class StepCard extends StatelessWidget {
  const StepCard({
    super.key,
    required this.number,
    required this.title,
    required this.helper,
    required this.child,
    this.invalid = false,
    this.errorText,
  });

  final int number;
  final String title;
  final String helper;
  final Widget child;
  final bool invalid;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final format = AppFormat.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.card),
        side: BorderSide(
          color: invalid ? scheme.error : scheme.outlineVariant,
          width: invalid ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Space.l - Space.half),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: l10n.stepNumberSemantics(format.integer(number)),
                  excludeSemantics: true,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                    child: Text(
                      format.integer(number),
                      textScaler: TextScaler.noScaling,
                      style: theme.textTheme.titleMedium?.copyWith(color: scheme.onPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: Space.m - Space.half),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(header: true, child: Text(title, style: theme.textTheme.titleLarge)),
                      const SizedBox(height: Space.half),
                      Text(
                        helper,
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.m),
            child,
            if (errorText case final message?) ...[
              const SizedBox(height: Space.m - Space.half),
              InlineError(message),
            ],
          ],
        ),
      ),
    );
  }
}
