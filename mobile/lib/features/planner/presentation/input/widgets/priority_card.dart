import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'package:nabta/core/theme/app_palette.dart';
import 'package:nabta/core/theme/app_theme.dart';
import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/presentation/planner_texts.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// A large selectable card for one priority: icon, title, one-line
/// explanation, and an animated check, all in the priority's color.
class PriorityCard extends StatelessWidget {
  const PriorityCard({
    super.key,
    required this.priority,
    required this.selected,
    required this.onToggle,
  });

  final Priority priority;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = priority.tones(AppPalette.of(context));
    final duration = Motion.of(context, Motion.short);
    final titleColor = selected ? tones.onContainer : scheme.onSurface;
    final bodyColor = selected ? tones.onContainer : scheme.onSurfaceVariant;

    return Semantics(
      checked: selected,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? tones.container : AppTheme.cardColor(scheme),
          borderRadius: BorderRadius.circular(Radii.input),
          border: Border.all(
            color: selected ? tones.accent : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.input),
            onTap: () {
              HapticFeedback.selectionClick();
              onToggle();
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 72),
              child: Padding(
                padding: const EdgeInsetsDirectional.all(Space.m),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? AppTheme.cardColor(scheme)
                            : tones.container,
                      ),
                      child: Icon(priority.icon, color: tones.onContainer),
                    ),
                    const SizedBox(width: Space.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            priority.title(l10n),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: titleColor,
                            ),
                          ),
                          Text(
                            priority.description(l10n),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: bodyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Space.s),
                    AnimatedSwitcher(
                      duration: duration,
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        selected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        key: ValueKey(selected),
                        size: 28,
                        color: selected ? tones.onContainer : scheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
