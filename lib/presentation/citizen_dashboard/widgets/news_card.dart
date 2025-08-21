import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
          news['image'] != null
              ? ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CustomImageWidget(
              imageUrl: news['image'] as String,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color:
              AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'article',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 12.w,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news['category'] as String? ?? 'समाचार',
                        style:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatTimestamp(
                          news['timestamp'] as DateTime? ?? DateTime.now()),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  news['headline'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  news['summary'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11.sp,
                    height: 1.4,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      news['location'] as String? ?? 'भद्रपुर नगरपालिका',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'visibility',
                          color:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${news['views'] ?? 0}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} मिनेट अगाडि';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} घण्टा अगाडि';
    } else if (difference.inDays == 1) {
      return 'हिजो';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} दिन अगाडि';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
