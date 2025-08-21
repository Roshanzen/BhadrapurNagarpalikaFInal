import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

enum Priority { low, medium, high }

class PrioritySelectorWidget extends StatefulWidget {
  final Priority? selectedPriority;
  final Function(Priority?) onPriorityChanged;
  final bool isOfficerMode;

  const PrioritySelectorWidget({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.isOfficerMode,
  });

  @override
  State<PrioritySelectorWidget> createState() => _PrioritySelectorWidgetState();
}

class _PrioritySelectorWidgetState extends State<PrioritySelectorWidget> {
  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'न्यून / Low';
      case Priority.medium:
        return 'मध्यम / Medium';
      case Priority.high:
        return 'उच्च / High';
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return AppTheme.priorityLow;
      case Priority.medium:
        return AppTheme.priorityMedium;
      case Priority.high:
        return AppTheme.priorityHigh;
    }
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.keyboard_arrow_down;
      case Priority.medium:
        return Icons.remove;
      case Priority.high:
        return Icons.keyboard_arrow_up;
    }
  }

  Widget _buildPriorityOption(Priority priority) {
    final isSelected = widget.selectedPriority == priority;
    final color = _getPriorityColor(priority);

    return InkWell(
      onTap: () => widget.onPriorityChanged(priority),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getPriorityIcon(priority),
              size: 16,
              color: isSelected
                  ? color
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              _getPriorityLabel(priority),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOfficerMode) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.priority_high,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'प्राथमिकता / Priority',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'अधिकारी मात्र / Officer Only',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Priority.values.map(_buildPriorityOption).toList(),
        ),
        if (widget.selectedPriority != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getPriorityColor(widget.selectedPriority!)
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getPriorityColor(widget.selectedPriority!)
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: _getPriorityColor(widget.selectedPriority!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getPriorityDescription(widget.selectedPriority!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getPriorityColor(widget.selectedPriority!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getPriorityDescription(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'साधारण समस्या, २-३ दिनभित्र समाधान / Normal issue, resolve within 2-3 days';
      case Priority.medium:
        return 'मध्यम समस्या, १ दिनभित्र समाधान / Medium issue, resolve within 1 day';
      case Priority.high:
        return 'तत्काल समस्या, तुरुन्त समाधान आवश्यक / Urgent issue, immediate attention required';
    }
  }
}
