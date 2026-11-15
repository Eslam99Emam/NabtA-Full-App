import 'package:nabta/features/planner/domain/climate_provider.dart';

enum SeasonKind { warm, cool }

/// One growing window of a rotation.
class StageWindow {
  const StageWindow({
    required this.number,
    required this.kind,
    required this.startMonth,
    required this.endMonth,
    required this.year,
    required this.meanTemperatureC,
  });

  /// 1-based stage number.
  final int number;
  final SeasonKind kind;
  final int startMonth;
  final int endMonth;

  /// Calendar year in which the window starts.
  final int year;
  final double meanTemperatureC;
}

/// Splits the year into two six-month windows, April–September and
/// October–March. In the northern hemisphere April–September is the warm
/// window; in the southern hemisphere the same months are the cool window.
class SeasonCalendar {
  const SeasonCalendar();

  static const int aprilStart = 4;
  static const int aprilEnd = 9;
  static const int octoberStart = 10;
  static const int octoberEnd = 3;

  SeasonKind kindOf({required int startMonth, required double latitude}) {
    final isAprilWindow = startMonth == aprilStart;
    final isNorthern = latitude >= 0;
    return isAprilWindow == isNorthern ? SeasonKind.warm : SeasonKind.cool;
  }

  /// [count] alternating windows, starting with the next window to begin
  /// after [from].
  List<StageWindow> upcomingWindows({
    required double latitude,
    required DateTime from,
    required int count,
    required ClimateProvider climate,
  }) {
    final inAprilWindow = from.month >= aprilStart && from.month <= aprilEnd;
    var startMonth = inAprilWindow ? octoberStart : aprilStart;
    var year = from.month >= octoberStart ? from.year + 1 : from.year;

    final windows = <StageWindow>[];
    for (var i = 0; i < count; i++) {
      final kind = kindOf(startMonth: startMonth, latitude: latitude);
      windows.add(
        StageWindow(
          number: i + 1,
          kind: kind,
          startMonth: startMonth,
          endMonth: startMonth == aprilStart ? aprilEnd : octoberEnd,
          year: year,
          meanTemperatureC: climate.meanTemperatureC(latitude: latitude, season: kind),
        ),
      );
      if (startMonth == aprilStart) {
        startMonth = octoberStart;
      } else {
        startMonth = aprilStart;
        year += 1;
      }
    }
    return windows;
  }
}
