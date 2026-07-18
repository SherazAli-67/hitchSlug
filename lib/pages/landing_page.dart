import 'package:flutter/material.dart';
import 'package:hitch_profile_slug_deeplink/core/app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../profile/seo_meta.dart';
import '../widgets/page_shell.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const double _desktopBreakpoint = 900;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    applyDefaultSeo();
    return Title(
      title: StringConst.webAppTitle,
      color: AppColors.primaryColorVariant1,
      child: PageShell(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: isDesktop ? 32 : 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: isDesktop
                      ? _DesktopHero(
                          onAppStore: () => _openUrl(StringConst.appStoreUrl),
                          onPlayStore: () => _openUrl(StringConst.playStoreUrl),
                        )
                      : _MobileHero(
                          onAppStore: () => _openUrl(StringConst.appStoreUrl),
                          onPlayStore: () => _openUrl(StringConst.playStoreUrl),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero({
    required this.onAppStore,
    required this.onPlayStore,
  });

  final VoidCallback onAppStore;
  final VoidCallback onPlayStore;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 11,
          child: _HeroCopy(
            headlineSize: 56,
            onAppStore: onAppStore,
            onPlayStore: onPlayStore,
          ),
        ),
        const SizedBox(width: 32),
        const Expanded(
          flex: 9,
          child: _PhoneVisual(maxHeight: 560),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero({
    required this.onAppStore,
    required this.onPlayStore,
  });

  final VoidCallback onAppStore;
  final VoidCallback onPlayStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCopy(
          headlineSize: 36,
          onAppStore: onAppStore,
          onPlayStore: onPlayStore,
        ),
        const SizedBox(height: 32),
        const _PhoneVisual(maxHeight: 420),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.headlineSize,
    required this.onAppStore,
    required this.onPlayStore,
  });

  final double headlineSize;
  final VoidCallback onAppStore;
  final VoidCallback onPlayStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 18,
                color: AppColors.blueGreenColor,
              ),
              const SizedBox(width: 6),
              Text(
                StringConst.socialBadge,
                style: TextStyle(
                  fontFamily: StringConst.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${StringConst.headlineLead} ',
                style: TextStyle(
                  fontFamily: StringConst.fontFamily,
                  fontSize: headlineSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: StringConst.headlineAccent,
                style: TextStyle(
                  fontFamily: StringConst.fontFamily,
                  fontSize: headlineSize,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: AppColors.primaryGreenColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          StringConst.heroBody,
          style: TextStyle(
            fontFamily: StringConst.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: const Color(0xFF5A5A5A),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StoreBadgeButton(
              assetPath: AppIcons.appStoreBadgeAsset,
              onTap: onAppStore,
            ),
            _StoreBadgeButton(
              assetPath: AppIcons.playStoreBadgeAsset,
              onTap: onPlayStore,
            ),
          ],
        ),
      ],
    );
  }
}

class _StoreBadgeButton extends StatelessWidget {
  const _StoreBadgeButton({
    required this.assetPath,
    required this.onTap,
  });

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          assetPath,
          height: 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _PhoneVisual extends StatelessWidget {
  const _PhoneVisual({required this.maxHeight});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 360),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.backgroundColor.withValues(alpha: 0.55),
                    AppColors.backgroundColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            Image.asset(
              AppIcons.mobilePhoneAsset,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
