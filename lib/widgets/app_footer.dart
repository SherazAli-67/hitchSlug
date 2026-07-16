import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../core/app_icons.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const double _desktopBreakpoint = 900;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
        final horizontal = isDesktop ? 48.0 : 20.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: AppColors.headerFooterColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 36, horizontal, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _openUrl(StringConst.instagramUrl),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppIcons.icInstagramLogo,
                              height: 20,
                              width: 20,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              StringConst.followUs,
                              style: TextStyle(
                                fontFamily: StringConst.fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          StringConst.getInTouch,
                          style: TextStyle(
                            fontFamily: StringConst.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 6),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _openUrl(StringConst.contactEmailUrl),
                            child: const Text(
                              StringConst.contactEmail,
                              style: TextStyle(
                                fontFamily: StringConst.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StoreBadge(
                          assetPath: AppIcons.appStoreBadgeAsset,
                          onTap: () => _openUrl(StringConst.appStoreUrl),
                        ),
                        _StoreBadge(
                          assetPath: AppIcons.playStoreBadgeAsset,
                          onTap: () => _openUrl(StringConst.playStoreUrl),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: AppColors.primaryLightColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: 16,
                ),
                child: isDesktop
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringConst.footerRegions,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                          Text(
                            StringConst.footerCopyright,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConst.footerRegions,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            StringConst.footerCopyright,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StoreBadge extends StatelessWidget {
  const _StoreBadge({
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
          height: 44,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
