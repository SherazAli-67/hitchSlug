import 'embed_viewport_stub.dart'
    if (dart.library.html) 'embed_viewport_web.dart'
    as impl;

Object? listenEmbedViewportResize(
  void Function() onResize, {
  void Function()? onHeightApplied,
}) {
  return impl.listenEmbedViewportResize(
    onResize,
    onHeightApplied: onHeightApplied,
  );
}

void cancelEmbedViewportResize(Object? handle) {
  impl.cancelEmbedViewportResize(handle);
}
