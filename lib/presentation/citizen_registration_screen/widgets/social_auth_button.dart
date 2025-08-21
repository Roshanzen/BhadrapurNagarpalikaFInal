import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialAuthButton extends StatelessWidget {
  final String provider;
  final String iconName;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialAuthButton({
    Key? key,
    required this.provider,
    required this.iconName,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
          elevation: 2,
          shadowColor: AppTheme.lightTheme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 3.h,
          width: 3.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Continue with $provider',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
