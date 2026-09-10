import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

const String _heightAppliedType = 'hitch-city-players-height-applied';

Object? listenEmbedViewportResize(
  void Function() onResize, {
  void Function()? onHeightApplied,
}) {
  final subs = <StreamSubscription>[
    html.window.onResize.listen((_) => onResize()),
  ];
  final viewport = html.window.visualViewport;
  if (viewport != null) {
    subs.add(viewport.onResize.listen((_) => onResize()));
  }
  if (onHeightApplied != null) {
    subs.add(
      html.window.onMessage.listen((event) {
        if (event.origin != html.window.location.origin) return;
        Object? data = event.data;
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {
            return;
          }
        }
        if (data is Map && data['type'] == _heightAppliedType) {
          onHeightApplied();
        }
      }),
    );
  }
  return subs;
}

void cancelEmbedViewportResize(Object? handle) {
  if (handle is! List<StreamSubscription>) {
    return;
  }
  for (final sub in handle) {
    sub.cancel();
  }
}
