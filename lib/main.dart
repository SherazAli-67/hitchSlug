import 'package:flutter/material.dart';

import 'pages/landing_page.dart';
import 'pages/public_profile_page.dart';
import 'profile/profile_slug.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.uri});

  final Uri? uri;

  @override
  Widget build(BuildContext context) {
    final resolvedUri = uri ?? Uri.base;
    final slug = extractProfileSlug(resolvedUri);

    final Widget home;
    if (isLandingPath(resolvedUri)) {
      home = const LandingPage();
    } else if (slug != null) {
      home = PublicProfilePage(slug: slug);
    } else {
      home = const ProfileNotFoundPage();
    }

    return MaterialApp(
      title: 'Hitch: Find Players & Court',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff90B953)),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
