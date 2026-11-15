import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'package:nabta/core/theme/spacing.dart';
import 'package:nabta/core/utils/motion.dart';
import 'package:nabta/core/widgets/content_layout.dart';
import 'package:nabta/core/widgets/nabta_logo.dart';
import 'package:nabta/l10n/gen/app_localizations.dart';

/// Friendly staged loading: soil → climate → rotations.
class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  static const Duration _stageTime = Duration(milliseconds: 550);
  static const int _lastStage = 2;
  Timer? _timer;
  int _stage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_stageTime, (timer) {
      if (_stage >= _lastStage) {
        timer.cancel();
        return;
      }
      setState(() => _stage += 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final steps = [l10n.loadingSoil, l10n.loadingClimate, l10n.loadingRotations];
    final duration = Motion.of(context, Motion.short);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(Space.l),
        child: ContentConstraint(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NabtaMark(size: 72),
              const SizedBox(height: Space.l),
              Semantics(
                liveRegion: true,
                child: Text(steps[_stage], style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
              ),
              const SizedBox(height: Space.l),
              for (final (index, label) in steps.indexed)
                AnimatedOpacity(
                  duration: duration,
                  opacity: index <= _stage ? 1 : 0.4,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: Space.m - Space.half),
                    child: Row(
                      children: [
                        SizedBox.square(
                          dimension: 24,
                          child: index < _stage
                              ? Icon(Icons.check_circle, color: scheme.primary)
                              : index == _stage
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.all(3),
                                      child: CircularProgressIndicator(strokeWidth: 2.5, color: scheme.primary),
                                    )
                                  : Icon(Icons.circle_outlined, color: scheme.outline),
                        ),
                        const SizedBox(width: Space.m - Space.half),
                        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
