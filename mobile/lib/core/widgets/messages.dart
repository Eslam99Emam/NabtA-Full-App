import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';

/// A localized error line with an icon, announced to screen readers.
class InlineError extends StatelessWidget {
  const InlineError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: scheme.error, size: 22),
          const SizedBox(width: Space.s),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// A soft tinted note with an icon (assumptions, tips).
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.icon,
    required this.message,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String message;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Radii.input),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Space.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground),
            const SizedBox(width: Space.m - Space.half),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small non-interactive stadium label with an icon.
class InfoPill extends StatelessWidget {
  const InfoPill({
    super.key,
    required this.icon,
    required this.label,
    this.semanticsLabel,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final String? semanticsLabel;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = foreground ?? scheme.onSurface;
    return Semantics(
      label: semanticsLabel ?? label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: background ?? scheme.surfaceContainerHigh,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(Space.m - Space.half, Space.half + 2, Space.m - Space.half, Space.half + 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: Space.half + 2),
              Flexible(
                child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
