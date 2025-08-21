import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileDrawer extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const ProfileDrawer({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildProfileSection(),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    thickness: 1,
                  ),
                  _buildMenuItems(context),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'प्रोफाइल',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CircleAvatar(
            radius: 8.w,
            backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            child: userProfile['avatar'] != null
                ? ClipOval(
              child: CustomImageWidget(
                imageUrl: userProfile['avatar'] as String,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.cover,
              ),
            )
                : CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            userProfile['name'] as String? ?? 'नागरिक',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            userProfile['email'] as String? ?? '',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'व्यक्तिगत जानकारी',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
              'फोन नम्बर', userProfile['phone'] as String? ?? 'N/A', 'phone'),
          _buildInfoRow('वार्ड नम्बर', 'वार्ड ${userProfile['ward'] ?? 'N/A'}',
              'location_city'),
          _buildInfoRow(
              'ठेगाना', userProfile['address'] as String? ?? 'N/A', 'home'),
          _buildInfoRow(
              'सदस्यता मिति',
              _formatDate(
                  userProfile['joinDate'] as DateTime? ?? DateTime.now()),
              'calendar_today'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {'title': 'सेटिङ्गहरू', 'icon': 'settings', 'route': '/settings'},
      {'title': 'सहायता', 'icon': 'help', 'route': '/help'},
      {'title': 'हाम्रो बारेमा', 'icon': 'info', 'route': '/about'},
      {'title': 'भाषा परिवर्तन', 'icon': 'language', 'route': '/language'},
      {'title': 'गोपनीयता नीति', 'icon': 'privacy_tip', 'route': '/privacy'},
    ];

    return Column(
      children: menuItems
          .map((item) => ListTile(
        leading: CustomIconWidget(
          iconName: item['icon'] as String,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
        title: Text(
          item['title'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        onTap: () {
          Navigator.pop(context);
          // Navigate to respective screens
        },
      ))
          .toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            title: Text(
              'लग आउट',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
          SizedBox(height: 1.h),
          Text(
            'भद्रपुर नगरपालिका गुनासो पोर्टल\nसंस्करण 1.0.0',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          'लग आउट',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'के तपाईं निश्चित हुनुहुन्छ कि तपाईं लग आउट गर्न चाहनुहुन्छ?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('रद्द गर्नुहोस्'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/role-selection-screen',
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'लग आउट',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
