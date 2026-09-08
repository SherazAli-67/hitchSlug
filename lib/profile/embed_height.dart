import 'embed_height_stub.dart'
    if (dart.library.html) 'embed_height_web.dart' as impl;

void notifyCityPlayersEmbedHeight({
  required int playerCount,
  required bool isDesktop,
  required bool hasMore,
  required bool compactState,
}) {
  impl.notifyCityPlayersEmbedHeight(
    playerCount: playerCount,
    isDesktop: isDesktop,
    hasMore: hasMore,
    compactState: compactState,
  );
}
