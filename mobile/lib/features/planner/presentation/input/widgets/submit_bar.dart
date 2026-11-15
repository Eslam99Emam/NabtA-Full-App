import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Sticky, full-width 56 dp call to action. Never disabled: tapping it with
/// missing input explains what to fix instead.
class SubmitBar extends StatelessWidget {
  const SubmitBar({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: BorderDirectional(
          top: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.m,
            Space.s + Space.half,
            Space.m,
            Space.m,
          ),
          child: ContentConstraint(
            child: SizedBox(
              // width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward),
                label: Text(AppLocalizations.of(context).getPlans),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
