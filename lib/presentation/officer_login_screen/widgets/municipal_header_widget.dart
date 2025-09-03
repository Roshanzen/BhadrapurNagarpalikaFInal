import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class MunicipalHeaderWidget extends StatelessWidget {
  final bool isNepali;

  const MunicipalHeaderWidget({super.key, this.isNepali = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo + Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 11.5.w,
                  backgroundImage: const AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 3.w),

              ],
            ),
            SizedBox(height: 2.h),

            // Title
            Text(
              isNepali ? 'भद्रपुर नगरपालिका' : 'Bhadrapur Municipality',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            Text(
              isNepali ? 'गुनासो व्यवस्थापन प्रणाली' : 'Complaint Management System',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Officer Portal
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                  SizedBox(width: 2.w),
                  Text(
                    isNepali ? 'अधिकारी पोर्टल' : 'Officer Portal',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
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