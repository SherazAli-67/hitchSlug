String? extractProfileSlug(Uri uri) {
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) {
    return null;
  }

  final playerIndex = segments.indexOf('player');
  if (playerIndex < 0 || playerIndex >= segments.length - 1) {
    return null;
  }

  final slug = segments.last.toLowerCase();
  if (!_slugPattern.hasMatch(slug)) {
    return null;
  }

  return slug;
}

bool isLandingPath(Uri uri) {
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  return segments.isEmpty;
}

final RegExp _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
