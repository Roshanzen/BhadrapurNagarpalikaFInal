import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyNoticeModal extends StatelessWidget {
  const PrivacyNoticeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Data Collection',
                    'Bhadrapur Nagarpalika collects personal information including your name, email, phone number, and ward details to provide municipal services and process complaints effectively.',
                  ),
                  _buildSection(
                    'Information Usage',
                    'Your personal data is used exclusively for municipal service delivery, complaint tracking, and official communication. We do not share your information with third parties without consent.',
                  ),
                  _buildSection(
                    'Data Security',
                    'We implement industry-standard security measures to protect your personal information. All data is encrypted and stored securely on government-approved servers.',
                  ),
                  _buildSection(
                    'Your Rights',
                    'You have the right to access, modify, or delete your personal information at any time. Contact our support team for assistance with data-related requests.',
                  ),
                  _buildSection(
                    'Cookies and Tracking',
                    'Our application uses minimal tracking for service improvement and user experience enhancement. No personal data is shared with advertising networks.',
                  ),
                  _buildSection(
                    'Contact Information',
                    'For privacy-related concerns or questions, contact Bhadrapur Nagarpalika at privacy@bhadrapurnagarpalika.gov.np or visit our office during business hours.',
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'By using this application, you agree to our privacy policy and terms of service.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Close button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'I Understand',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
