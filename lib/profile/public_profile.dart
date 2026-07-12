class PlayerLevel {
  const PlayerLevel({
    required this.levelRank,
    required this.levelTitle,
  });

  final String levelRank;
  final String levelTitle;

  factory PlayerLevel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PlayerLevel(levelRank: '', levelTitle: '');
    }
    return PlayerLevel(
      levelRank: (json['levelRank'] as String?) ?? '',
      levelTitle: (json['levelTitle'] as String?) ?? '',
    );
  }

  String get display {
    if (levelTitle.isNotEmpty && levelRank.isNotEmpty) {
      return '$levelTitle ($levelRank)';
    }
    if (levelTitle.isNotEmpty) {
      return levelTitle;
    }
    return levelRank;
  }

  bool get hasValue => display.isNotEmpty;
}

class PublicProfile {
  const PublicProfile({
    required this.userID,
    required this.userName,
    required this.profileSlug,
    required this.profilePicture,
    required this.bio,
    required this.playerTypePickle,
    required this.playerTypeTennis,
    required this.playerTypePadel,
    required this.playerTypeCoach,
    required this.level,
    required this.isConnectedToDupr,
    required this.duprSingleRating,
    required this.duprDoubleRating,
    required this.vbrValue,
    required this.playStyle,
    required this.gender,
    required this.locationStringArray,
    required this.pickleBallPlayerLevel,
    required this.tennisBallPlayerLevel,
    required this.padelBallPlayerLevel,
    required this.sportsPhotos,
  });

  final String userID;
  final String userName;
  final String profileSlug;
  final String profilePicture;
  final String bio;
  final bool playerTypePickle;
  final bool playerTypeTennis;
  final bool playerTypePadel;
  final bool playerTypeCoach;
  final String level;
  final bool isConnectedToDupr;
  final num? duprSingleRating;
  final num? duprDoubleRating;
  final num? vbrValue;
  final String? playStyle;
  final String? gender;
  final List<String> locationStringArray;
  final PlayerLevel pickleBallPlayerLevel;
  final PlayerLevel tennisBallPlayerLevel;
  final PlayerLevel padelBallPlayerLevel;
  final List<String> sportsPhotos;

  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      userID: (json['userID'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? '',
      profileSlug: (json['profileSlug'] as String?) ?? '',
      profilePicture: (json['profilePicture'] as String?) ?? '',
      bio: (json['bio'] as String?) ?? '',
      playerTypePickle: json['playerTypePickle'] == true,
      playerTypeTennis: json['playerTypeTennis'] == true,
      playerTypePadel: json['playerTypePadel'] == true,
      playerTypeCoach: json['playerTypeCoach'] == true,
      level: (json['level'] as String?) ?? '',
      isConnectedToDupr: json['isConnectedToDupr'] == true,
      duprSingleRating: json['duprSingleRating'] as num?,
      duprDoubleRating: json['duprDoubleRating'] as num?,
      vbrValue: json['vbrValue'] as num?,
      playStyle: json['playStyle'] as String?,
      gender: json['gender'] as String?,
      locationStringArray: (json['locationStringArray'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
      pickleBallPlayerLevel: PlayerLevel.fromJson(
        json['pickleBallPlayerLevel'] as Map<String, dynamic>?,
      ),
      tennisBallPlayerLevel: PlayerLevel.fromJson(
        json['tennisBallPlayerLevel'] as Map<String, dynamic>?,
      ),
      padelBallPlayerLevel: PlayerLevel.fromJson(
        json['padelBallPlayerLevel'] as Map<String, dynamic>?,
      ),
      sportsPhotos: (json['sportsPhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  List<String> get sports {
    final values = <String>[];
    if (playerTypePickle) values.add('Pickleball');
    if (playerTypeTennis) values.add('Tennis');
    if (playerTypePadel) values.add('Padel');
    if (playerTypeCoach) values.add('Coach');
    return values;
  }

  String get cityDisplay {
    if (locationStringArray.isEmpty) {
      return '';
    }
    return locationStringArray.join(', ');
  }
}
