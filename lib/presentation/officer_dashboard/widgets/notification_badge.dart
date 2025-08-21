import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(2.w),
        child: Stack(
          children: [
            CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            count > 0
                ? Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 4.w,
                  minHeight: 4.w,
                ),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style:
                  AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
