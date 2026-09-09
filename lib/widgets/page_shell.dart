import 'package:flutter/material.dart';

import 'app_footer.dart';
import 'app_header.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.child,
    this.onLogoTap,
    this.centerBody = false,
    this.showHeader = true,
    this.showFooter = true,
    this.disableBodyScroll = false,
  });

  final Widget child;
  final VoidCallback? onLogoTap;
  final bool centerBody;
  final bool showHeader;
  final bool showFooter;
  final bool disableBodyScroll;

  @override
  Widget build(BuildContext context) {
    if (disableBodyScroll) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: centerBody
            ? Center(child: child)
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: child,
              ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (showHeader) AppHeader(onLogoTap: onLogoTap),
          if (centerBody) ...[
            Expanded(child: Center(child: child)),
            if (showFooter) const AppFooter(),
          ] else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [child, if (showFooter) const AppFooter()],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
