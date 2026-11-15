import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:nabta/features/planner/data/remote/crop_recommendation_dto.dart';
import 'package:nabta/features/planner/data/remote/recommendation_mapper.dart';
import 'package:nabta/features/planner/data/strategy_profiles.dart';
import 'package:nabta/features/planner/domain/land_input.dart';
import 'package:nabta/features/planner/domain/priority.dart';
import 'package:nabta/features/planner/domain/rotation.dart';
import 'package:nabta/features/planner/domain/rotation_repository.dart';

/// The server answered, but not with a success status.
class RemoteRotationException implements Exception {
  const RemoteRotationException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'RemoteRotationException($statusCode): $body';
}

/// Gets plans from `POST {baseUrl}/recommend`.
///
/// The API accepts a single `priority`, while the app lets the grower pick
/// several. So one request is sent per selected priority, in parallel, and
/// each response becomes one plan (labelled "Water saver", "Soil builder" or
/// "Market driver"). Plans come back best fit first.
class RemoteRotationRepository implements RotationRepository {
  RemoteRotationRepository({
    required String baseUrl,
    http.Client? client,
    RecommendationMapper? mapper,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 20),
    this.minimumDelay = const Duration(milliseconds: 800),
  }) : _endpoint = Uri.parse(
         '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/recommend',
       ),
       _client = client ?? http.Client(),
       _mapper = mapper ?? const RecommendationMapper(),
       _clock = clock ?? DateTime.now;

  final Uri _endpoint;
  final http.Client _client;
  final RecommendationMapper _mapper;
  final DateTime Function() _clock;
  final Duration timeout;

  /// Keeps the loading state readable instead of flashing on fast responses.
  final Duration minimumDelay;

  @override
  Future<List<RotationStrategy>> recommend(LandInput input) async {
    log("Started Recommendation");
    final today = _clock();
    // Display order, so the result is deterministic.
    final priorities = [
      for (final p in Priority.values)
        if (input.priorities.contains(p)) p,
    ];
    log("Preparing Recommendation");
    final (plans, _) = await (
      Future.wait([for (final p in priorities) _plan(input, p, today)]),
      Future<void>.delayed(minimumDelay),
    ).wait;
    log(plans.toString());
    return [for (final plan in plans) ?plan]
      ..sort((a, b) => b.fit.compareTo(a.fit));
  }

  Future<RotationStrategy?> _plan(
    LandInput input,
    Priority priority,
    DateTime today,
  ) async {
    log("Started planning");
    final items = await _post(input, priority);
    log("Finished planning");
    return _mapper.toStrategy(
      items: items,
      input: input,
      profile: _profileFor(priority),
      today: today,
    );
  }

  Future<List<CropRecommendationDto>> _post(
    LandInput input,
    Priority priority,
  ) async {
    log("Started posting");
    final response = await _client
        .post(
          _endpoint,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'lat': input.latitude,
            'lon': input.longitude,
            'area_hectares': input.areaM2 / 10000,
            'soil_ph': input.ph,
            'priority': _apiPriority(priority),
          }),
        )
        .timeout(timeout);
    log("Ended requesting");
    log('POST $_endpoint');

    // Decode the raw bytes as UTF-8: the common-name list contains non-ASCII
    // text, and `response.body` would fall back to Latin-1 if the server does
    // not declare a charset.
    final text = utf8.decode(response.bodyBytes);
    log("Ended decoding");
    log("Ended decoding ${response.statusCode}, ${text}");
    if (response.statusCode < 200 || response.statusCode >= 300) {
      log("Problem");
      throw RemoteRotationException(response.statusCode, text);
    }
    log("Ended posting");

    final json = jsonDecode(text);
    if (json is! List) {
      throw const FormatException('Expected a JSON array from /recommend');
    }
    log("Ended posting");
    return [
      for (final entry in json)
        CropRecommendationDto.fromJson(entry as Map<String, dynamic>),
    ];
  }

  /// Only `water_conserving` is confirmed by the sample request. The other
  /// two are inferred from the response's score names; adjust them here if the
  /// API uses different values.
  static String _apiPriority(Priority priority) => switch (priority) {
    Priority.water => 'water_conserving',
    Priority.nitrogen => 'nitrogen_fixing',
    Priority.market => 'market_suitability',
  };

  static StrategyProfile _profileFor(Priority priority) {
    final id = switch (priority) {
      Priority.water => 'water_saver',
      Priority.nitrogen => 'soil_builder',
      Priority.market => 'market_driver',
    };
    return strategyProfiles.firstWhere((profile) => profile.id == id);
  }
}
