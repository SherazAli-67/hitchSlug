import 'package:flutter/material.dart';

import 'app_footer.dart';
import 'app_header.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.child,
    this.onLogoTap,
    this.centerBody = false,
  });

  final Widget child;
  final VoidCallback? onLogoTap;
  final bool centerBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppHeader(onLogoTap: onLogoTap),
          if (centerBody) ...[
            Expanded(child: Center(child: child)),
            const AppFooter(),
          ] else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    child,
                    const AppFooter(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
