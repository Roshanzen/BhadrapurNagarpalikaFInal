import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComplaintCategoryCard extends StatelessWidget {
  final String title;
  final String iconName;
  final int count;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ComplaintCategoryCard({
    super.key,
    required this.title,
    required this.iconName,
    required this.count,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        width: 42.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: backgroundColor,
                        size: 6.w,
                      ),
                    ),
                  ),
                  count > 0
                      ? Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 5.w,
                        minHeight: 5.w,
                      ),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: AppTheme.lightTheme.textTheme.labelSmall
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onError,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildQuickActionTile(
              context,
              'View Status',
              'visibility',
                  () => Navigator.pop(context),
            ),
            _buildQuickActionTile(
              context,
              'Add Comment',
              'comment',
                  () => Navigator.pop(context),
            ),
            _buildQuickActionTile(
              context,
              'Share',
              'share',
                  () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      BuildContext context,
      String title,
      String iconName,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}