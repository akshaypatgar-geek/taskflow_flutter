import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileMaxWidth = AppTokens.breakpointMd,
    this.tabletMaxWidth = AppTokens.breakpointLg,
    this.desktopMaxWidth = AppTokens.breakpointXxl,
  });

  final Widget child;
  final double mobileMaxWidth;
  final double tabletMaxWidth;
  final double desktopMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final maxWidth = width >= desktopMaxWidth
            ? desktopMaxWidth
            : width >= tabletMaxWidth
                ? tabletMaxWidth
                : mobileMaxWidth;
        final horizontalPadding = width >= tabletMaxWidth
            ? AppTokens.sXxxl
            : AppTokens.sXl;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
