import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;

const String cityPlayersEmbedHeightMessageType = 'hitch-city-players-height';

void notifyCityPlayersEmbedHeight({
  required int playerCount,
  required int crossAxisCount,
  required bool hasMore,
  required bool compactState,
}) {
  final parent = html.window.parent;
  if (identical(parent, html.window)) {
    return;
  }

  final estimated = _estimateHeight(
    playerCount: playerCount,
    crossAxisCount: crossAxisCount,
    hasMore: hasMore,
    compactState: compactState,
  );

  final doc = html.document;
  final body = doc.body;
  final docEl = doc.documentElement;
  final measured = math.max(
    body?.scrollHeight ?? 0,
    math.max(docEl?.scrollHeight ?? 0, 0),
  ).toDouble();

  final height = compactState
      ? math.max(measured, 320)
      : math.max(estimated, measured);

  parent?.postMessage(
    jsonEncode({
      'type': cityPlayersEmbedHeightMessageType,
      'height': height.round(),
    }),
    html.window.location.origin,
  );
}

double _estimateHeight({
  required int playerCount,
  required int crossAxisCount,
  required bool hasMore,
  required bool compactState,
}) {
  if (compactState) {
    return 320;
  }

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
