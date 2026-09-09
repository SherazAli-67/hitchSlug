import 'dart:async';
import 'dart:html' as html;

Object? listenEmbedViewportResize(void Function() onResize) {
  final subs = <StreamSubscription<html.Event>>[
    html.window.onResize.listen((_) => onResize()),
  ];
  final viewport = html.window.visualViewport;
  if (viewport != null) {
    subs.add(viewport.onResize.listen((_) => onResize()));
  }
  return subs;
}

void cancelEmbedViewportResize(Object? handle) {
  if (handle is! List<StreamSubscription<html.Event>>) {
    return;
  }
  for (final sub in handle) {
    sub.cancel();
  }
}
