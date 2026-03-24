import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/utils/constants.dart';

import '../theme/app_tokens.dart';

class AdaptiveNavRail extends StatelessWidget {
  const AdaptiveNavRail({
    super.key,
    required this.selectedIndex,
    required this.child,
  });

  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) return child;

        return Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.goNamed(ScreenPaths.tasks.name);
                  case 1:
                    context.goNamed(ScreenPaths.profile.name);
                  case 2:
                    context.goNamed(ScreenPaths.categories.name);
                }
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  selectedIcon: Icon(Icons.task_alt),
                  label: Text(AppStrings.tasks),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text(AppStrings.profile),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: Text(AppStrings.categories),
                ),
              ],
            ),
            const VerticalDivider(width: AppTokens.s),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
