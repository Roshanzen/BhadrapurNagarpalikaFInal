import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MunicipalHeaderWidget extends StatelessWidget {
  final bool isNepali;

  const MunicipalHeaderWidget({
    Key? key,
    this.isNepali = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Municipal Logo and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Municipal Logo
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'account_balance',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Officer Badge
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'badge',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Municipal Name
            Text(
              isNepali ? 'भद्रपुर नगरपालिका' : 'Bhadrapur Municipality',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),

            // Subtitle
            Text(
              isNepali
                  ? 'गुनासो व्यवस्थापन प्रणाली'
                  : 'Complaint Management System',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Officer Portal Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'admin_panel_settings',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isNepali ? 'अधिकारी पोर्टल' : 'Officer Portal',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
