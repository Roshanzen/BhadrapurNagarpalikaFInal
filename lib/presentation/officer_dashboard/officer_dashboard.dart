import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/notification_badge.dart';
import './incoming_complaints_page.dart';
import './all_complaints_page.dart';
import './resolved_complaints_page.dart';
import './suchana_page.dart';
import './profile_page.dart';
import './officer_complaint_form.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  int _notificationCount = 5;
  String _selectedLanguage = 'ne'; // Default to Nepali

  // Complaint categories with compact design
  List<Map<String, dynamic>> get complaintCategories => [
    {
      "title": LanguageManager.getString('incoming_complaints', _selectedLanguage),
      "icon": "inbox",
      "count": 12,
      "color": AppTheme.lightTheme.colorScheme.primary,
    },
    {
      "title": LanguageManager.getString('all_complaints', _selectedLanguage),
      "icon": "list_alt",
      "count": 45,
      "color": AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      "title": LanguageManager.getString('resolved_complaints', _selectedLanguage),
      "icon": "check_circle",
      "count": 28,
      "color": AppTheme.lightTheme.colorScheme.tertiary,
    }
  ];

  void _navigateToComplaintCategory(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IncomingComplaintsPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllComplaintsPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResolvedComplaintsPage()),
        );
        break;
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  Widget _buildNoticeCard({
    required String imageUrl,
    required String title,
    required String date,
    required String excerpt,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuchanaPage()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 65.w,
        constraints: BoxConstraints(
          maxWidth: 300,
          minWidth: 250,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Image
            Container(
              height: 16.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Notice Content
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      date,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Title
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

                  // Excerpt
                  Text(
                    excerpt,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOfficerComplaintForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OfficerComplaintForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(LanguageManager.getString('officer_dashboard', _selectedLanguage)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          NotificationBadge(
            count: _notificationCount,
            onTap: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: _navigateToProfile,
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint Categories - Compact Design
            Text(
              LanguageManager.getString('complaints', _selectedLanguage),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            // 3 Compact Category Icons in a Row - Made Responsive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(complaintCategories.length, (index) {
                final category = complaintCategories[index];
                return Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () => _navigateToComplaintCategory(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      padding: EdgeInsets.all(2.w),
                      constraints: BoxConstraints(
                        minWidth: 20.w,
                        maxWidth: 28.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              color: category["color"].withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: category["icon"],
                              color: category["color"],
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          Flexible(
                            child: Text(
                              category["title"],
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: category["color"],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${category["count"]}',
                              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 4.h),

            // Suchana Notice Board Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '📋 ${LanguageManager.getString('notice_board', _selectedLanguage)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuchanaPage()),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  tooltip: LanguageManager.getString('add_notice', _selectedLanguage),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Notice Board with Photos and Titles
            Container(
              height: 32.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                children: [
                  // Notice 1
                  _buildNoticeCard(
                    imageUrl: 'https://images.pexels.com/photos/8761412/pexels-photo-8761412.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1',
                    title: 'नगरपालिका सभाको सूचना',
                    date: '२०८१/०५/०७',
                    excerpt: 'आगामी २०८१/०५/१५ गते नगरपालिका सभा बस्ने भएकोले...',
                  ),
                  SizedBox(width: 3.w),

                  // Notice 2
                  _buildNoticeCard(
                    imageUrl: 'https://images.pexels.com/photos/6230579/pexels-photo-6230579.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1',
                    title: 'सफाई अभियान कार्यक्रम',
                    date: '२०८१/०५/०६',
                    excerpt: 'आगामी शुक्रबार वडा नं. ५ मा सफाई अभियान सञ्चालन...',
                  ),
                  SizedBox(width: 3.w),

                  // Notice 3
                  _buildNoticeCard(
                    imageUrl: 'https://images.pexels.com/photos/1181396/pexels-photo-1181396.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1',
                    title: 'कर संकलन अभियान',
                    date: '२०८१/०५/१०',
                    excerpt: 'यो आर्थिक वर्षको कर संकलन अभियान सुरु भएको...',
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // View All Notices Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuchanaPage()),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  LanguageManager.getString('view_all', _selectedLanguage),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToOfficerComplaintForm,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'edit',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(LanguageManager.getString('submit_complaint', _selectedLanguage)),
      ),
    );
  }
}
