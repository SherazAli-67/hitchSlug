import 'dart:async';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import 'app_deep_link.dart';

Future<void> openPlayerInApp(String slug) async {
  if (_isAndroid) {
    final intentUri = _buildAndroidIntentUri(slug);
    html.window.location.href = intentUri;
    return;
  }

  if (!_isIOS) {
    await launchUrl(Uri.parse(StringConst.appStoreUrl));
    return;
  }

  html.window.location.href = buildAppDeepLinkUri(slug).toString();

  await Future<void>.delayed(const Duration(milliseconds: 2000));

  if (html.document.visibilityState != 'visible') {
    return;
  }

  html.window.location.href = StringConst.appStoreUrl;
}

String _buildAndroidIntentUri(String slug) {
  final fallback = Uri.encodeComponent(StringConst.playStoreUrl);
  return 'intent://player/$slug#Intent;'
      'scheme=${StringConst.appDeepLinkScheme};'
      'package=com.willparton.hitch;'
      'S.browser_fallback_url=$fallback;'
      'end';
}

bool get _isIOS {
  final ua = html.window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod');
}

bool get _isAndroid {
  return html.window.navigator.userAgent.toLowerCase().contains('android');
}
