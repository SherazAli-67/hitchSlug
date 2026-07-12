import 'package:hitch_profile_slug_deeplink/constants/string_const.dart';
import 'package:hitch_profile_slug_deeplink/core/models/uploaded_file_model.dart';

import 'coach_experience_model.dart';
import 'player_level_model.dart';
import 'package:timeago/timeago.dart' as timeago;
class UserModel {
  String userID;
  String userName;
  String profileSlug;
  String profilePicture;
  bool playerTypePickle;
  bool playerTypeTennis;
  bool playerTypePadel;
  bool playerTypeCoach;
  bool coachFilter;
  String level;
  String bio;
  String cellNumber;
  String emailAddress;
  String? age;
  String? experience;
  double distanceFromCurrentLocation;
  final String token;
  List<String> requestSentToUserIDs;
  List<String> hiddenIds;
  List<String> requestReceivedFromUserIDs;
  List<String> reactIds;
  String? gender;
  String? shot;
  final bool isReviewed;


  List<String> declinedRequestsUserIDs;
  double? latitude;
  double? longitude;
  PlayerLevelModel? pickleBallPlayerLevel;
  PlayerLevelModel? tennisBallPlayerLevel;
  PlayerLevelModel? padelBallPlayerLevel;
  CoachExperienceModel? coachPickleBallExperienceLevel;
  CoachExperienceModel? coachTennisBallExperienceLevel;
  CoachExperienceModel? coachPadelBallExperienceLevel;
  List<UploadedFileModel> uploadedSportsPhotos;
  bool isAvailableDaily;
  bool isAvailableInMorning;
  String matchType;
  String genderType;
  String? myDuprID;
  bool isConnectedToDupr;
  double? duprSingleRating;
  double? duprDoubleRating;
  List<String> availableDaysToPlay;
  bool showEventsNoti = true;
  int? lastActive;
  String get lastActiveTime {
    if (lastActive == null) {
      return '';
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(lastActive!);
    return timeago.format(dateTime, locale: 'en').replaceAll('about ', '');
  }
  int joinedTime;
  bool isTop = false;
  int topCount = 0;
  bool isNew = false;
  bool isPaid = false;
  bool viewedHitches = false;
  double? vbrValue;
  String? playStyle;
  List<String> locationStringArray;

  UserModel({
    required this.userID,
    required this.userName,
    this.profileSlug = '',
    required this.profilePicture,
    required this.playerTypePickle,
    required this.playerTypeTennis,
    required this.playerTypePadel,
    required this.playerTypeCoach,
    this.coachFilter = true,
    this.level = '',
    required this.bio,
    required this.cellNumber,
    required this.emailAddress,
    this.latitude,
    this.longitude,
    this.gender,
    this.shot,
    this.distanceFromCurrentLocation = 10,
    this.age,
    this.token = '',
    this.experience,
    this.requestReceivedFromUserIDs = const [],
    this.hiddenIds = const [],
    this.declinedRequestsUserIDs = const [],
    this.requestSentToUserIDs = const [],
    this.reactIds = const [],
    this.coachPickleBallExperienceLevel,
    this.coachTennisBallExperienceLevel,
    this.coachPadelBallExperienceLevel,
    this.pickleBallPlayerLevel,
    this.tennisBallPlayerLevel,
    this.padelBallPlayerLevel,
    this.uploadedSportsPhotos = const [],
    this.isAvailableDaily = true,
    this.isAvailableInMorning = false,
    this.matchType = 'Both',
    this.genderType = 'Both',
    this.myDuprID,
    this.isConnectedToDupr = false,
    this.duprDoubleRating,
    this.duprSingleRating,
    required this.availableDaysToPlay,
    this.showEventsNoti = true,
    this.isReviewed = false,
    this.lastActive,
    this.joinedTime = 0,
    this.isTop = false,
    this.topCount = 0,
    this.isNew = false,
    this.isPaid = false,
    this.viewedHitches = false,
    this.vbrValue,
    this.playStyle,
    this.locationStringArray = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      StringConst.profileSlugKey: profileSlug,
      'profilePicture': profilePicture,
      'playerTypePickle': playerTypePickle,
      'playerTypeTennis': playerTypeTennis,
      'playerTypePadel': playerTypePadel,
      'playerTypeCoach': playerTypeCoach,
      'coachFilter': coachFilter,
      'level': level,
      'bio': bio,
      'cellNumber': cellNumber,
      'emailAddress': emailAddress,
      'age': age,
      'experience': experience,
      'token': token,
      'distanceFromCurrentLocation': distanceFromCurrentLocation,
      'requestSentToUserIDs': requestSentToUserIDs,
      'hiddenIds': hiddenIds,
      'requestReceivedFromUserIDs': requestReceivedFromUserIDs,
      'declinedRequestsUserIDs': requestReceivedFromUserIDs,
      'reactIds': reactIds,
      // 'languages' : languages,
      'latitude': latitude,
      'longitude': longitude,
      'gender': gender,
      'shot': shot,
      'myDuprID': myDuprID,
      'isConnectedToDupr': isConnectedToDupr,
      'duprDoubleRating': duprDoubleRating,
      'duprSingleRating': duprSingleRating,
      'coachPickleBallExperienceLevel': coachPickleBallExperienceLevel?.toMap(),
      'coachTennisBallExperienceLevel': coachTennisBallExperienceLevel?.toMap(),
      'coachPadelBallExperienceLevel': coachPadelBallExperienceLevel?.toMap(),
      'pickleBallPlayerLevel': pickleBallPlayerLevel?.toMap(),
      'tennisBallPlayerLevel': tennisBallPlayerLevel?.toMap(),
      'padelBallPlayerLevel': padelBallPlayerLevel?.toMap(),
      'showEventsNoti': showEventsNoti,
      StringConst.uploadedFilesKey: uploadedSportsPhotos
          .map((uploadedSportsPhotos) => uploadedSportsPhotos.toMap())
          .toList(),
      StringConst.isAvailableDailyKey: isAvailableDaily,
      StringConst.isAvailableInMorningKey: isAvailableInMorning,
      StringConst.matchTypeKey: matchType,
      StringConst.genderTypeKey: genderType,
      StringConst.availableDaysToPlayKey: availableDaysToPlay,
      StringConst.isReviewedKey: isReviewed,
      'lastActive': lastActive,
      'joinedTime': joinedTime,
      'isTop': isTop,
      'topCount': topCount,
      'isNew': isNew,
      'isPaid': isPaid,
      'viewedHitches': viewedHitches,
      'vbrValue': vbrValue,
      'playStyle': playStyle,
      StringConst.locationStringArrayKey: locationStringArray,
    };
  }

  // Create a UserProfile object from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userID: map['userID'],
        userName: map['userName'],
        profileSlug: map[StringConst.profileSlugKey] ?? '',
        profilePicture: map['profilePicture'],
        playerTypePickle: map['playerTypePickle'] ?? true,
        playerTypeTennis: map['playerTypeTennis'] ?? true,
        playerTypePadel: map['playerTypePadel'] ?? true,
        playerTypeCoach: map['playerTypeCoach'] ?? false,
        coachFilter: map['coachFilter'] ?? true,
        isTop: map['isTop'] ?? false,
        topCount: map['topCount'] ?? 0,
        isNew: map['isNew'] ?? false,
        isPaid: map['isPaid'] ?? false,
        level: map['level'],
        bio: map['bio'],
        cellNumber: map['cellNumber'],
        emailAddress: map['emailAddress'],
        age: map['age'],
        experience: map['experience'],
        token: map['token'] ?? '',
        distanceFromCurrentLocation: map['distanceFromCurrentLocation'] > 20
            ? 20
            : map['distanceFromCurrentLocation'],
        requestSentToUserIDs:
            List<String>.from(map['requestSentToUserIDs'] ?? []),
        hiddenIds: List<String>.from(map['hiddenIds'] ?? []),
        reactIds: List<String>.from(map['reactIds'] ?? []),
        declinedRequestsUserIDs:
            List<String>.from(map['declinedRequestsUserIDs'] ?? []),
        // languages: List<String>.from(map['languages'] ?? []),
        requestReceivedFromUserIDs:
            List<String>.from(map['requestReceivedFromUserIDs'] ?? []),
        latitude: map['latitude'],
        longitude: map['longitude'],
        gender: map['gender'],
        shot: map['shot'],
        myDuprID: map['myDuprID'],
        isConnectedToDupr: map['isConnectedToDupr'] ?? false,
        duprDoubleRating: map['duprDoubleRating'],
        duprSingleRating: map['duprSingleRating'],
        coachPickleBallExperienceLevel:
            map['coachPickleBallExperienceLevel'] != null
                ? CoachExperienceModel.fromMap(
                    map['coachPickleBallExperienceLevel'])
                : null,
        coachTennisBallExperienceLevel:
            map['coachTennisBallExperienceLevel'] != null
                ? CoachExperienceModel.fromMap(
                    map['coachTennisBallExperienceLevel'])
                : null,
        coachPadelBallExperienceLevel: map['coachPadelBallExperienceLevel'] !=
                null
            ? CoachExperienceModel.fromMap(map['coachPadelBallExperienceLevel'])
            : null,
        pickleBallPlayerLevel: map['pickleBallPlayerLevel'] != null
            ? PlayerLevelModel.fromMap(map['pickleBallPlayerLevel'])
            : null,
        tennisBallPlayerLevel: map['tennisBallPlayerLevel'] != null
            ? PlayerLevelModel.fromMap(map['tennisBallPlayerLevel'])
            : null,
        padelBallPlayerLevel: map['padelBallPlayerLevel'] != null
            ? PlayerLevelModel.fromMap(map['padelBallPlayerLevel'])
            : null,
        uploadedSportsPhotos: (map['uploadedFiles'] as List<dynamic>? ?? [])
            .map((fileMap) =>
                UploadedFileModel.fromMap(fileMap as Map<String, dynamic>))
            .toList(),
        isAvailableDaily: map[StringConst.isAvailableDailyKey] ?? true,
        showEventsNoti: map['showEventsNoti'] ?? true,
        isAvailableInMorning: map[StringConst.isAvailableInMorningKey] ?? false,
        matchType: map[StringConst.matchTypeKey] ?? 'Both',
        genderType: map[StringConst.genderTypeKey] ?? 'Both',
        isReviewed: map[StringConst.isReviewedKey] ?? false,
        lastActive: map['lastActive'],
        joinedTime: map['joinedTime'] ?? 0,
        viewedHitches: map['viewedHitches'] ?? false,
        vbrValue: map['vbrValue'],
        playStyle: map['playStyle'],
        locationStringArray: List<String>.from(
          map[StringConst.locationStringArrayKey] ?? [],
        ),
        availableDaysToPlay: List<String>.from(
          map[StringConst.availableDaysToPlayKey] ?? [],
        ));
  }

  factory UserModel.fromPublicJson(Map<String, dynamic> json) {
    PlayerLevelModel? levelFrom(dynamic value) {
      if (value is Map<String, dynamic>) {
        return PlayerLevelModel.fromMap(value);
      }
      return null;
    }

    final photos = <UploadedFileModel>[];
    final sportsPhotos = json['sportsPhotos'] as List<dynamic>? ?? [];
    for (final item in sportsPhotos) {
      if (item is String && item.isNotEmpty) {
        photos.add(UploadedFileModel(fileName: '', url: item));
      } else if (item is Map<String, dynamic>) {
        final url = (item['url'] as String?) ?? '';
        if (url.isNotEmpty) {
          photos.add(
            UploadedFileModel(
              fileName: (item['fileName'] as String?) ?? '',
              url: url,
            ),
          );
        }
      }
    }
    if (photos.isEmpty) {
      final uploaded = json['uploadedFiles'] as List<dynamic>? ?? [];
      for (final item in uploaded) {
        if (item is Map<String, dynamic>) {
          final url = (item['url'] as String?) ?? '';
          if (url.isNotEmpty) {
            photos.add(
              UploadedFileModel(
                fileName: (item['fileName'] as String?) ?? '',
                url: url,
              ),
            );
          }
        }
      }
    }

    return UserModel(
      userID: (json['userID'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? '',
      profileSlug: (json[StringConst.profileSlugKey] as String?) ??
          (json['profileSlug'] as String?) ??
          '',
      profilePicture: (json['profilePicture'] as String?) ?? '',
      playerTypePickle: json['playerTypePickle'] == true,
      playerTypeTennis: json['playerTypeTennis'] == true,
      playerTypePadel: json['playerTypePadel'] == true,
      playerTypeCoach: json['playerTypeCoach'] == true,
      level: (json['level'] as String?) ?? '',
      bio: (json['bio'] as String?) ?? '',
      cellNumber: (json['cellNumber'] as String?) ?? '',
      emailAddress: (json['emailAddress'] as String?) ?? '',
      gender: json['gender'] as String?,
      shot: json['shot'] as String?,
      playStyle: (json['playStyle'] as String?) ?? (json['shot'] as String?),
      isConnectedToDupr: json['isConnectedToDupr'] == true,
      duprSingleRating: (json['duprSingleRating'] as num?)?.toDouble(),
      duprDoubleRating: (json['duprDoubleRating'] as num?)?.toDouble(),
      vbrValue: (json['vbrValue'] as num?)?.toDouble(),
      pickleBallPlayerLevel: levelFrom(json['pickleBallPlayerLevel']),
      tennisBallPlayerLevel: levelFrom(json['tennisBallPlayerLevel']),
      padelBallPlayerLevel: levelFrom(json['padelBallPlayerLevel']),
      uploadedSportsPhotos: photos,
      reactIds: List<String>.from(json['reactIds'] ?? const []),
      locationStringArray: List<String>.from(
        json[StringConst.locationStringArrayKey] ??
            json['locationStringArray'] ??
            const [],
      ),
      availableDaysToPlay: const [],
      distanceFromCurrentLocation: 10,
    );
  }

  List<String> get activeSports {
    final values = <String>[];
    if (playerTypePickle) values.add(StringConst.playerTypePickleBallValue);
    if (playerTypeTennis) values.add(StringConst.playerTypeTennisValue);
    if (playerTypePadel) values.add(StringConst.playerTypePadelValue);
    if (playerTypeCoach) values.add(StringConst.playerTypeCoachValue);
    return values;
  }

  String get locationDisplay {
    if (locationStringArray.isEmpty) {
      return '';
    }
    if (locationStringArray.length >= 2) {
      return '${locationStringArray[0]}, ${locationStringArray[1]}';
    }
    return locationStringArray.first;
  }

  double? get primaryDuprRating {
    if (duprDoubleRating != null) {
      return duprDoubleRating;
    }
    return duprSingleRating;
  }

  String get primaryLevelTitle {
    for (final level in [
      pickleBallPlayerLevel,
      tennisBallPlayerLevel,
      padelBallPlayerLevel,
    ]) {
      final title = level?.levelTitle ?? '';
      if (title.isNotEmpty) {
        return title;
      }
    }
    return level;
  }

  void setUserID({required String userID}) {
    this.userID = userID;
  }

  void setProfileUrl({required String profilePicture}) {
    this.profilePicture = profilePicture;
  }
}
