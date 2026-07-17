import 'open_in_app_stub.dart'
    if (dart.library.html) 'open_in_app_web.dart' as impl;

export 'app_deep_link.dart';

Future<void> openPlayerInApp(String slug) {
  return impl.openPlayerInApp(slug);
}
