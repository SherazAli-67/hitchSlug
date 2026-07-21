import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/string_const.dart';
import '../core/models/player_level_model.dart';

class CityPlayersApiException implements Exception {
  CityPlayersApiException(this.message);

  final String message;
}

class PublicCityPlayer {
  const PublicCityPlayer({
    required this.userID,
    required this.userName,
    required this.profileSlug,
    required this.profilePicture,
    required this.city,
    required this.playerTypePickle,
    required this.playerTypeTennis,
    required this.playerTypePadel,
    required this.playerTypeCoach,
    this.cityLowerCase = '',
    this.level = '',
    this.playStyle = '',
    this.duprSingleRating,
    this.duprDoubleRating,
    this.pickleBallPlayerLevel,
    this.tennisBallPlayerLevel,
    this.padelBallPlayerLevel,
  });

  final String userID;
  final String userName;
  final String profileSlug;
  final String profilePicture;
  final String city;
  final String cityLowerCase;
  final bool playerTypePickle;
  final bool playerTypeTennis;
  final bool playerTypePadel;
  final bool playerTypeCoach;
  final String level;
  final String playStyle;
  final double? duprSingleRating;
  final double? duprDoubleRating;
  final PlayerLevelModel? pickleBallPlayerLevel;
  final PlayerLevelModel? tennisBallPlayerLevel;
  final PlayerLevelModel? padelBallPlayerLevel;

  factory PublicCityPlayer.fromJson(Map<String, dynamic> json) {
    return PublicCityPlayer(
      userID: (json['userID'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? '',
      profileSlug: (json['profileSlug'] as String?) ?? '',
      profilePicture: (json['profilePicture'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      cityLowerCase: (json['cityLowerCase'] as String?) ?? '',
      playerTypePickle: json['playerTypePickle'] == true,
      playerTypeTennis: json['playerTypeTennis'] == true,
      playerTypePadel: json['playerTypePadel'] == true,
      playerTypeCoach: json['playerTypeCoach'] == true,
      level: (json['level'] as String?) ?? '',
      playStyle: (json['playStyle'] as String?) ?? '',
      duprSingleRating: (json['duprSingleRating'] as num?)?.toDouble(),
      duprDoubleRating: (json['duprDoubleRating'] as num?)?.toDouble(),
      pickleBallPlayerLevel: _levelFrom(json['pickleBallPlayerLevel']),
      tennisBallPlayerLevel: _levelFrom(json['tennisBallPlayerLevel']),
      padelBallPlayerLevel: _levelFrom(json['padelBallPlayerLevel']),
    );
  }

  static PlayerLevelModel? _levelFrom(dynamic value) {
    if (value is Map) {
      return PlayerLevelModel.fromMap(Map<String, dynamic>.from(value));
    }
    return null;
  }

  List<String> get activeSports {
    final values = <String>[];
    if (playerTypePickle) values.add(StringConst.playerTypePickleBallValue);
    if (playerTypeTennis) values.add(StringConst.playerTypeTennisValue);
    if (playerTypePadel) values.add(StringConst.playerTypePadelValue);
    if (playerTypeCoach) values.add(StringConst.playerTypeCoachValue);
    return values;
  }

  String get primarySport => activeSports.isEmpty ? '' : activeSports.first;

  double? get primaryDuprRating {
    if (duprDoubleRating != null) return duprDoubleRating;
    return duprSingleRating;
  }

  PlayerLevelModel? get _primaryLevel {
    if (playerTypePickle) return pickleBallPlayerLevel;
    if (playerTypeTennis) return tennisBallPlayerLevel;
    if (playerTypePadel) return padelBallPlayerLevel;
    return pickleBallPlayerLevel ??
        tennisBallPlayerLevel ??
        padelBallPlayerLevel;
  }

  String get primaryLevelTitle {
    final title = _primaryLevel?.levelTitle.trim() ?? '';
    if (title.isNotEmpty) return title;
    return level.trim();
  }

  String get _sportPrefix {
    if (playerTypePickle) return 'pickleball-partners';
    if (playerTypeTennis) return 'tennis-partners';
    if (playerTypePadel) return 'padel-partners';
    return 'pickleball-partners';
  }

  String deepLinkPath({required String fallbackCitySlug}) {
    final slug = profileSlug.trim().toLowerCase();
    final rawCity = cityLowerCase.isNotEmpty
        ? cityLowerCase
        : (city.isNotEmpty ? city : fallbackCitySlug);
    final citySegment = _slugify(rawCity);
    final levelSegment = _slugify(primaryLevelTitle);

    final segments = <String>[
      _sportPrefix,
      'player',
      if (citySegment.isNotEmpty) citySegment,
      if (levelSegment.isNotEmpty) levelSegment,
      slug,
    ];
    return '/${segments.join('/')}';
  }
}

String _slugify(String input) {
  return input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'[^a-z0-9.+-]'), '')
      .replaceAll(RegExp(r'-{2,}'), '-')
      .replaceAll(RegExp(r'(^-+)|(-+$)'), '');
}

class CityPlayersResult {
  const CityPlayersResult({
    required this.city,
    required this.players,
  });

  final String city;
  final List<PublicCityPlayer> players;
}

class CityPlayersApi {
  CityPlayersApi({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl =
      'https://us-central1-hitches-mobile-app.cloudfunctions.net/getPublicPlayersByCity';

  final http.Client _client;

  Future<CityPlayersResult> fetchByCity(String citySlug) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {'city': citySlug},
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw CityPlayersApiException(
        'Failed to load players (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw CityPlayersApiException('Unexpected response shape');
    }

    final rawPlayers = decoded['players'];
    if (rawPlayers is! List) {
      throw CityPlayersApiException('Unexpected players payload');
    }

    final players = rawPlayers
        .whereType<Map>()
        .map(
          (item) => PublicCityPlayer.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    return CityPlayersResult(
      city: (decoded['city'] as String?) ?? citySlug,
      players: players,
    );
  }
}
