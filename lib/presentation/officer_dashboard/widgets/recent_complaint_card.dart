import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentComplaintCard extends StatelessWidget {
  final String complaintId;
  final String title;
  final String citizenName;
  final String submissionDate;
  final String priority;
  final String status;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const RecentComplaintCard({
    super.key,
    required this.complaintId,
    required this.title,
    required this.citizenName,
    required this.submissionDate,
    required this.priority,
    required this.status,
    required this.onTap,
    this.onLongPress,
  });

  Color _getPriorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'उच्च':
        return AppTheme.priorityHigh;
      case 'medium':
      case 'मध्यम':
        return AppTheme.priorityMedium;
      case 'low':
      case 'न्यून':
        return AppTheme.priorityLow;
      default:
        return AppTheme.priorityMedium;
    }
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'बाँकी':
        return AppTheme.statusPending;
      case 'in progress':
      case 'प्रगतिमा':
        return AppTheme.statusInProgress;
      case 'completed':
      case 'सम्पन्न':
        return AppTheme.statusCompleted;
      case 'rejected':
      case 'अस्वीकृत':
        return AppTheme.statusRejected;
      default:
        return AppTheme.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '#$complaintId',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    priority,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    citizenName,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    submissionDate,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
