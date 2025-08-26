import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/complaint_category_card.dart';
import './widgets/notification_badge.dart';
import './widgets/officer_profile_card.dart';
import './widgets/recent_complaint_card.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({super.key});

  @override
  State<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  int _notificationCount = 5;

  // Mock officer data
  final Map<String, dynamic> officerData = {
    "id": 1,
    "name": "राम बहादुर श्रेष्ठ",
    "designation": "सहायक प्रशासकीय अधिकृत",
    "profileImage":
    "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "department": "सामान्य प्रशासन",
    "phone": "+977-9841234567",
    "email": "ram.shrestha@bhadrapur.gov.np"
  };

  // Mock complaint categories data
  final List<Map<String, dynamic>> complaintCategories = [
    {
      "id": 1,
      "title": "आएको गुनासो",
      "subtitle": "नयाँ प्राप्त गुनासोहरू",
      "icon": "inbox",
      "count": 12,
      "color": "primary",
      "route": "/incoming-complaints"
    },
    {
      "id": 2,
      "title": "सम्पूर्ण गुनासो",
      "subtitle": "सबै गुनासोहरूको सूची",
      "icon": "list_alt",
      "count": 45,
      "color": "secondary",
      "route": "/all-complaints"
    },
    {
      "id": 3,
      "title": "समाधान गरेको गुनासो",
      "subtitle": "समाधान भएका गुनासोहरू",
      "icon": "check_circle",
      "count": 28,
      "color": "success",
      "route": "/resolved-complaints"
    }
  ];

  // Mock recent complaints data
  final List<Map<String, dynamic>> recentComplaints = [
    {
      "id": "C001",
      "title": "सडक बत्ती बिग्रिएको",
      "citizenName": "श्याम कुमार राई",
      "submissionDate": "२०८१/०५/०७",
      "priority": "उच्च",
      "status": "बाँकी",
      "ward": 5,
      "category": "पूर्वाधार"
    },
    {
      "id": "C002",
      "title": "पानीको ट्याङ्की सफाई",
      "citizenName": "गीता देवी पौडेल",
      "submissionDate": "२०८१/०५/०६",
      "priority": "मध्यम",
      "status": "प्रगतिमा",
      "ward": 3,
      "category": "सफाई"
    },
    {
      "id": "C003",
      "title": "कुकुर नियन्त्रण",
      "citizenName": "हरि प्रसाद अधिकारी",
      "submissionDate": "२०८१/०५/०५",
      "priority": "न्यून",
      "status": "सम्पन्न",
      "ward": 8,
      "category": "स्वास्थ्य"
    },
    {
      "id": "C004",
      "title": "फोहोर संकलन समस्या",
      "citizenName": "सुनिता गुरुङ",
      "submissionDate": "२०८१/०५/०४",
      "priority": "उच्च",
      "status": "बाँकी",
      "ward": 12,
      "category": "सफाई"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // ensure FAB visibility updates when tab changes
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String colorName) {
    switch (colorName) {
      case 'primary':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'secondary':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'success':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _notificationCount = 3; // Update notification count after refresh
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('डाटा अपडेट भयो'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('लगआउट'),
          content: const Text('के तपाईं लगआउट गर्न चाहनुहुन्छ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('रद्द गर्नुहोस्'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, '/role-selection-screen');
              },
              child: const Text('लगआउट'),
            ),
          ],
        );
      },
    );
  }

  void _showComplaintActions(Map<String, dynamic> complaint) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'गुनासो #${complaint["id"]}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('विस्तृत हेर्नुहोस्'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to complaint details
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
                title: const Text('स्थिति अपडेट गर्नुहोस्'),
                onTap: () {
                  Navigator.pop(context);
                  // Show status update dialog
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                title: const Text('नागरिकलाई सम्पर्क गर्नुहोस्'),
                onTap: () {
                  Navigator.pop(context);
                  // Contact citizen
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Officer Profile Card
            OfficerProfileCard(
              officerName: officerData["name"] as String,
              designation: officerData["designation"] as String,
              profileImage: officerData["profileImage"] as String,
              onLogout: _showLogoutDialog,
            ),

            SizedBox(height: 2.h),

            // Complaint Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'गुनासो श्रेणीहरू',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),

            SizedBox(height: 1.h),

            ...complaintCategories.map((category) => ComplaintCategoryCard(
              title: category["title"] as String,
              subtitle: category["subtitle"] as String,
              iconName: category["icon"] as String,
              count: category["count"] as int,
              backgroundColor:
              _getCategoryColor(category["color"] as String),
              onTap: () {
                // Navigate to specific complaint category
                Navigator.pushNamed(context, category["route"] as String);
              },
            )),

            SizedBox(height: 3.h),

            // Recent Complaints Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'हालका गुनासोहरू',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all complaints
                      Navigator.pushNamed(context, '/all-complaints');
                    },
                    child: const Text('सबै हेर्नुहोस्'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: recentComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = recentComplaints[index];
                  return RecentComplaintCard(
                    complaintId: complaint["id"] as String,
                    title: complaint["title"] as String,
                    citizenName: complaint["citizenName"] as String,
                    submissionDate: complaint["submissionDate"] as String,
                    priority: complaint["priority"] as String,
                    status: complaint["status"] as String,
                    onTap: () {
                      // Navigate to complaint details
                    },
                    onLongPress: () {
                      _showComplaintActions(complaint);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            '$title निर्माणाधीन छ',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('अधिकृत ड्यासबोर्ड'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading:
        false, // 🚫 removes the default back icon & behavior
        actions: [
          NotificationBadge(
            count: _notificationCount,
            onTap: () {
              // Navigate to notifications
            },
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor: AppTheme.lightTheme.colorScheme.onPrimary
              .withValues(alpha: 0.7),
          indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
          labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
          tabs: const [
            Tab(text: 'ड्यासबोर्ड'),
            Tab(text: 'गुनासो'),
            Tab(text: 'सूचना'),
            Tab(text: 'प्रोफाइल'),
          ],
        ),
      ),
      body: _isRefreshing
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'डाटा लोड गर्दै...',
              style:
              AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPlaceholderTab('गुनासो'),
          _buildPlaceholderTab('सूचना बोर्ड'),
          _buildPlaceholderTab('प्रोफाइल'),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          // Show complaint response form
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return Container(
                height: 80.h,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme
                            .onSurfaceVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'गुनासो जवाफ फारम',
                      style: AppTheme
                          .lightTheme.textTheme.titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Center(
                        child: Text(
                          'गुनासो जवाफ फारम निर्माणाधीन छ',
                          style: AppTheme.lightTheme.textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: const Text('जवाफ दिनुहोस्'),
      )
          : null,
    );
  }
}
