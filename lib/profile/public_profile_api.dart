import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/models/user_model.dart';

class PublicProfileNotFoundException implements Exception {}

class PublicProfileApiException implements Exception {
  PublicProfileApiException(this.message);

  final String message;
}

class PublicProfileApi {
  PublicProfileApi({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl =
      'https://us-central1-hitches-mobile-app.cloudfunctions.net/getPublicProfileBySlug';

  final http.Client _client;

  Future<UserModel> fetchBySlug(String slug) async {
    /*return UserModel(userID: "00Dog6EjA9fNVz4O5F0wJOaqh0A3",
        userName: 'Ehsan',
        profilePicture: 'https://firebasestorage.googleapis.com/v0/b/hitches-mobile-app.appspot.com/o/profilePictures%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2F6AA48ABF-C046-4365-B658-82142FF7374D%2Ftmp%2Fimage_picker_C1D5D0F3-177F-4204-A507-A050A3232391-2982-000000BAE4398BED.jpg?alt=media&token=44e15018-3bb5-46f9-a7a5-736da23e0229',
        playerTypePickle: true,
        playerTypeTennis: false,
        playerTypePadel: false,
        playerTypeCoach: false,
        bio: "Pickle ball player",
        cellNumber: "+923072215500",
        emailAddress: "ehsan@gmail.com",
        availableDaysToPlay: ['Monday', "Tuesday"]);*/
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {'slug': slug});
    final response = await _client.get(uri);

    if (response.statusCode == 404) {
      throw PublicProfileNotFoundException();
    }

    if (response.statusCode != 200) {
      throw PublicProfileApiException(
        'Failed to load profile (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw PublicProfileApiException('Unexpected response shape');
    }

    return UserModel.fromPublicJson(decoded);
  }
}
