import 'package:url_launcher/url_launcher.dart';

import 'app_deep_link.dart';

Future<void> openPlayerInApp(String slug) async {
  final uri = buildAppDeepLinkUri(slug);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
