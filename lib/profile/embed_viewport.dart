import 'embed_viewport_stub.dart'
    if (dart.library.html) 'embed_viewport_web.dart' as impl;

Object? listenEmbedViewportResize(void Function() onResize) {
  return impl.listenEmbedViewportResize(onResize);
}

void cancelEmbedViewportResize(Object? handle) {
  impl.cancelEmbedViewportResize(handle);
}
