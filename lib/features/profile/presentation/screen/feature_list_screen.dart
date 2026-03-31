import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/core/widgets/network_aware_app_bar.dart';
import 'package:taskflowapp/core/widgets/responsive_container.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';

class FeatureListScreen extends StatelessWidget {
  const FeatureListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: NetworkAwareAppBar(
        leading: context.canPop()
            ? Semantics(
                label: AppStrings.back,
                tooltip: AppStrings.back,
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: AppStrings.back,
                  onPressed: () => context.pop(),
                ),
              )
            : null,
        title: const Text(AppStrings.featureList),
      ),
      body: ResponsiveContainer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppTokens.sXl),
          children: const [
            _FeatureCard(
              icon: Icons.task_alt,
              title: AppStrings.featureTaskManagementTitle,
              description: AppStrings.featureTaskManagementDescription,
            ),
            SizedBox(height: AppTokens.sM),
            _FeatureCard(
              icon: Icons.sync,
              title: AppStrings.featureRealtimeSyncTitle,
              description: AppStrings.featureRealtimeSyncDescription,
            ),
            SizedBox(height: AppTokens.sM),
            _FeatureCard(
              icon: Icons.cloud_off_outlined,
              title: AppStrings.featureOfflineTitle,
              description: AppStrings.featureOfflineDescription,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SurfaceCard(
      padding: const EdgeInsets.all(AppTokens.sXl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: AppTokens.sL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppTokens.s / 2),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
