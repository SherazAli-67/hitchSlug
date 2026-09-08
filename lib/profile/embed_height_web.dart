import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;

const String cityPlayersEmbedHeightMessageType = 'hitch-city-players-height';

void notifyCityPlayersEmbedHeight({
  required int playerCount,
  required bool isDesktop,
  required bool hasMore,
  required bool compactState,
}) {
  final parent = html.window.parent;
  if (identical(parent, html.window)) {
    return;
  }

  final height = _estimateHeight(
    playerCount: playerCount,
    isDesktop: isDesktop,
    hasMore: hasMore,
    compactState: compactState,
  );

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
  required bool isDesktop,
  required bool hasMore,
  required bool compactState,
}) {
  if (compactState) {
    return 420;
  }

  final columns = isDesktop ? 3 : 1;
  final cardHeight = isDesktop ? 470.0 : 560.0;
  final spacing = isDesktop ? 20.0 : 16.0;
  final rows = math.max(1, (playerCount / columns).ceil());
  const header = 140.0;
  const verticalPadding = 80.0;
  final loadMore = hasMore ? 92.0 : 24.0;

  return header +
      verticalPadding +
      (rows * cardHeight) +
      ((rows - 1) * spacing) +
      loadMore;
}
