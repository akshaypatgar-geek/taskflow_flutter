import 'package:flutter/material.dart';

import '../theme/app_decorations.dart';
import '../theme/app_tokens.dart';

/// Card-style container with app surface styling (elevation, radius, shadow).
/// Use for form containers and content blocks across auth, tasks, profile.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTokens.sXxl),
      decoration: AppDecorations.surfaceCard(context),
      child: child,
    );
  }
}
