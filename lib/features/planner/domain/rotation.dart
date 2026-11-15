import 'package:nabta/features/planner/domain/crop.dart';
import 'package:nabta/features/planner/domain/localized_text.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/season.dart';

/// All 0–100 scores for one crop in one window.
class CropScores {
  const CropScores({
    required this.soil,
    required this.climate,
    required this.water,
    required this.nitrogen,
    required this.market,
  });

  final int soil;
  final int climate;
  final int water;
  final int nitrogen;
  final int market;

  int forPriority(Priority priority) => switch (priority) {
        Priority.water => water,
        Priority.nitrogen => nitrogen,
        Priority.market => market,
      };

  CropScores copyWith({int? soil, int? climate, int? water, int? nitrogen, int? market}) {
    return CropScores(
      soil: soil ?? this.soil,
      climate: climate ?? this.climate,
      water: water ?? this.water,
      nitrogen: nitrogen ?? this.nitrogen,
      market: market ?? this.market,
    );
  }
}

class RotationStage {
  const RotationStage({required this.window, required this.crop, required this.scores});

  final StageWindow window;
  final Crop crop;
  final CropScores scores;
}

/// A named search profile. `weights == null` means "use the grower's own
/// priority weights".
class StrategyProfile {
  const StrategyProfile({
    required this.id,
    required this.name,
    required this.rationale,
    this.weights,
  });

  final String id;
  final LocalizedText name;

  /// One line: why this plan works.
  final LocalizedText rationale;
  final Map<Priority, double>? weights;
}

class RotationStrategy {
  const RotationStrategy({
    required this.profile,
    required this.stages,
    required this.fit,
    required this.waterDemandM3,
  });

  final StrategyProfile profile;
  final List<RotationStage> stages;

  /// 0–100 overall fit under the grower's weights.
  final int fit;

  /// Σ seasonalWaterMm × area_m² / 1000.
  final double waterDemandM3;

  int get stageCount => stages.length;
}
