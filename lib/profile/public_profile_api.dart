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
