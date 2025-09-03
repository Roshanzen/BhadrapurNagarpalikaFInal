import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuchanaBoardCard extends StatelessWidget {
  final Map<String, dynamic> notice;

  const SuchanaBoardCard({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
            AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notice['image'] != null
              ? ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CustomImageWidget(
              imageUrl: notice['image'] as String,
              width: 70.w,
              height: 12.h,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            width: 70.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'announcement',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notice['category'] as String? ?? 'सूचना',
                        style:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(
                          notice['date'] as DateTime? ?? DateTime.now()),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  notice['title'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  notice['description'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      notice['author'] as String? ?? 'Municipal Office',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'आज';
    } else if (difference.inDays == 1) {
      return 'हिजो';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} दिन अगाडि';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
