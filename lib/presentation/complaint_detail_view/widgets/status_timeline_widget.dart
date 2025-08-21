import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatusUpdate {
  final String id;
  final String status;
  final String message;
  final String officerName;
  final DateTime timestamp;
  final List<String>? attachments;

  StatusUpdate({
    required this.id,
    required this.status,
    required this.message,
    required this.officerName,
    required this.timestamp,
    this.attachments,
  });
}

class StatusTimelineWidget extends StatelessWidget {
  final List<StatusUpdate> updates;
  final bool isOfficer;

  const StatusTimelineWidget({
    super.key,
    required this.updates,
    required this.isOfficer,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'पेश गरियो':
        return AppTheme.statusPending;
      case 'in-progress':
      case 'प्रगतिमा':
        return AppTheme.statusInProgress;
      case 'resolved':
      case 'समाधान भयो':
        return AppTheme.statusCompleted;
      case 'rejected':
      case 'अस्वीकृत':
        return AppTheme.statusRejected;
      default:
        return AppTheme.statusPending;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'पेश गरियो':
        return Icons.assignment_turned_in;
      case 'in-progress':
      case 'प्रगतिमा':
        return Icons.build;
      case 'resolved':
      case 'समाधान भयो':
        return Icons.check_circle;
      case 'rejected':
      case 'अस्वीकृत':
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return 'अहिले / Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} मिनेट अगाडि / ${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} घण्टा अगाडि / ${diff.inHours} hr ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} दिन अगाडि / ${diff.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget _buildTimelineItem(StatusUpdate update, bool isLast, BuildContext context) {
    final statusColor = _getStatusColor(update.status);
    final statusIcon = _getStatusIcon(update.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 18,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: statusColor.withValues(alpha: 0.3),
                margin: const EdgeInsets.only(top: 4),
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Timeline content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        update.status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDateTime(update.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  update.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),

                // Officer name
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      update.officerName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                // Attachments
                if (update.attachments?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: update.attachments!.map((attachment) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.attachment,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              attachment,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color:
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (updates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 48,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'कुनै अपडेट उपलब्ध छैन\nNo updates available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.timeline,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'स्थिति अपडेट / Status Timeline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${updates.length} अपडेट',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: updates.asMap().entries.map((entry) {
            final index = entry.key;
            final update = entry.value;
            final isLast = index == updates.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _buildTimelineItem(update, isLast, context),
            );
          }).toList(),
        ),
      ],
    );
  }
}