import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_icons.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.onLogoTap,
  });

  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: MouseRegion(
                cursor: onLogoTap != null
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: onLogoTap,
                  child: Image.asset(
                    AppIcons.icHitchLogo,
                    height: 32,
                    fit: BoxFit.contain,
                    color: AppColors.darkGreyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
