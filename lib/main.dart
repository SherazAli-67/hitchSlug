import 'package:flutter/material.dart';

import 'constants/string_const.dart';
import 'core/app_colors.dart';
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
  /*  if (isLandingPath(resolvedUri)) {
      home = const LandingPage();
    } else if (slug != null) {
      home = PublicProfilePage(slug: slug);
    } else {
      home = const ProfileNotFoundPage();
    }*/

    home = PublicProfilePage(slug: 'sheraz-nazir');
    return MaterialApp(
      title: StringConst.webAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: StringConst.fontFamily,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColorVariant1,
          primary: AppColors.primaryColorVariant1,
        ),
      ),
      home: home,
    );
  }
}
