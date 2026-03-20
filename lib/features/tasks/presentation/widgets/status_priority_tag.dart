import 'package:flutter/material.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';

/// A row showing a label and an optional status/priority tag with theme colors.
/// Used in task details for Status and Priority.
class StatusPriorityTag extends StatelessWidget {
  const StatusPriorityTag({
    super.key,
    required this.label,
    this.value,
    this.isStatus = false,
    this.isPriority = false,
  });

  final String label;
  final String? value;
  final bool isStatus;
  final bool isPriority;

  Color? _tagColor(BuildContext context) {
    if (value == null) return null;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = AppStatusColors.of(context);
    switch (value!.toLowerCase()) {
      case 'open':
        return isStatus ? statusColors.open : null;
      case 'in_progress':
        return isStatus ? statusColors.inProgress : null;
      case 'completed':
        return isStatus ? statusColors.done : null;
      case 'high':
        return isPriority ? statusColors.highPriority : null;
      case 'medium':
        return isPriority ? statusColors.mediumPriority : null;
      case 'low':
        return isPriority ? statusColors.lowPriority : null;
      default:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tagColor = _tagColor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if (tagColor != null && value != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: tagColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                value ?? '-',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
