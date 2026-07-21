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

String? extractCitySlug(Uri uri) {
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.length < 2) {
    return null;
  }
  if (segments.first.toLowerCase() != 'players') {
    return null;
  }

  final citySlug = segments[1].toLowerCase();
  if (!_slugPattern.hasMatch(citySlug)) {
    return null;
  }

  return citySlug;
}

String citySlugToDisplayName(String citySlug) {
  return citySlug
      .split('-')
      .where((part) => part.isNotEmpty)
      .map(
        (part) =>
            '${part[0].toUpperCase()}${part.length > 1 ? part.substring(1) : ''}',
      )
      .join(' ');
}

bool isLandingPath(Uri uri) {
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  return segments.isEmpty;
}

final RegExp _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
