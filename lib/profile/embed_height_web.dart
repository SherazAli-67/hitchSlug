import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;

const String cityPlayersEmbedHeightMessageType = 'hitch-city-players-height';
const int _minEmbedHeight = 320;
const int _heightSlackPx = 8;

int? _lastPostedHeight;

void notifyCityPlayersEmbedHeight({
  double? contentHeight,
  required int playerCount,
  required int crossAxisCount,
  required bool hasMore,
  required bool compactState,
}) {
  final parent = html.window.parent;
  if (identical(parent, html.window)) {
    return;
  }

  final measured = contentHeight ?? 0;
  final double height;
  if (compactState) {
    height = math.max(measured, _minEmbedHeight.toDouble());
  } else if (measured > 0) {
    height = measured;
  } else {
    height = _estimateHeight(
      playerCount: playerCount,
      crossAxisCount: crossAxisCount,
      hasMore: hasMore,
    );
  }

  final rounded = math.max(_minEmbedHeight, height.ceil());
  final last = _lastPostedHeight;
  if (last != null && (rounded - last).abs() < _heightSlackPx) {
    return;
  }
  _lastPostedHeight = rounded;

  parent?.postMessage(
    jsonEncode({'type': cityPlayersEmbedHeightMessageType, 'height': rounded}),
    html.window.location.origin,
  );
}

double _estimateHeight({
  required int playerCount,
  required int crossAxisCount,
  required bool hasMore,
}) {
  final columns = math.max(1, crossAxisCount);
  final cardHeight = columns >= 3 ? 470.0 : 560.0;
  final spacing = columns >= 3 ? 20.0 : 16.0;
  final rows = math.max(1, (playerCount / columns).ceil());
  const verticalPadding = 48.0;
  final loadMore = hasMore ? 92.0 : 24.0;

  return verticalPadding +
      (rows * cardHeight) +
      ((rows - 1) * spacing) +
      loadMore;
}
