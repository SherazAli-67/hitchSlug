import 'embed_height_stub.dart'
    if (dart.library.html) 'embed_height_web.dart' as impl;

void notifyCityPlayersEmbedHeight({
  required int playerCount,
  required int crossAxisCount,
  required bool hasMore,
  required bool compactState,
}) {
  impl.notifyCityPlayersEmbedHeight(
    playerCount: playerCount,
    crossAxisCount: crossAxisCount,
    hasMore: hasMore,
    compactState: compactState,
  );
}
