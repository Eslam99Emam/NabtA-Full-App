import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Shown when planning fails, with a single clear retry.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(Space.l),
        child: ContentConstraint(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_outlined, size: 56, color: theme.colorScheme.error),
              const SizedBox(height: Space.m),
              Text(l10n.errorTitle, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: Space.s),
              Text(l10n.errorBody, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: Space.l),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
