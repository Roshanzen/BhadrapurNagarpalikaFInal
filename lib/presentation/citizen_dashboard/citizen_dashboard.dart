import '../gunaso_form/gunaso_form.dart';
import '../gunaso_form/widgets/my_complaint_page.dart';
import '../gunaso_form/widgets/pending_work_page.dart';
import '../gunaso_form/widgets/under_review_page.dart';
import '../gunaso_form/widgets/completed_complaints_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/complaint_category_card.dart';
import './widgets/profile_drawer.dart';
import './widgets/suchana_board_card.dart';

class CitizenDashboard extends StatefulWidget {
  final Map<String, dynamic>? googleUserData;

  const CitizenDashboard({Key? key, this.googleUserData}) : super(key: key);

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _notificationCount = 3;
  bool _showWelcomeBox = true;

  late Map<String, dynamic> _userProfile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize user profile with Google data if available
    _initializeUserProfile();

    // Auto-hide welcome box after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showWelcomeBox = false;
        });
      }
    });
  }

  void _initializeUserProfile() {
    if (widget.googleUserData != null) {
      // Use Google user data
      _userProfile = {
        "name": widget.googleUserData!['displayName'] ?? widget.googleUserData!['fullName'] ?? 'नागरिक',
        "email": widget.googleUserData!['email'] ?? '',
        "phone": "+977-XXXXXXXXXX", // Default phone, can be updated later
        "ward": 1, // Default ward, can be selected later
        "address": "भद्रपुर नगरपालिका", // Default address
        "avatar": widget.googleUserData!['photoUrl'] ?? widget.googleUserData!['picture'] ?? null,
        "joinDate": DateTime.now(),
        "isGoogleUser": true,
        "googleId": widget.googleUserData!['localId'] ?? '',
        "firstName": widget.googleUserData!['firstName'] ?? '',
        "lastName": widget.googleUserData!['lastName'] ?? '',
      };
    } else {
      // Use default profile
      _userProfile = {
        "name": "राम बहादुर श्रेष्ठ",
        "email": "ram.shrestha@gmail.com",
        "phone": "+977-9841234567",
        "ward": 5,
        "address": "भद्रपुर-५, झापा",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "joinDate": DateTime.now().subtract(Duration(days: 180)),
        "isGoogleUser": false,
      };
    }
  }

  final List<Map<String, dynamic>> _complaintCategories = [
    {
      "title": "आफ्नो गुनासो",
      "icon": "assignment",
      "count": 5,
      "color": AppTheme.lightTheme.colorScheme.primary,
      "route": "/my-complaints"
    },
    {
      "title": "काम भैरहेको गुनासो",
      "icon": "work",
      "count": 12,
      "color": AppTheme.lightTheme.colorScheme.secondary,
      "route": "/pending-work"
    },
    {
      "title": "सुनवाई भएको गुनासो",
      "icon": "hearing",
      "count": 8,
      "color": Color(0xFFF57C00),
      "route": "/under-review"
    },
    {
      "title": "सम्पूर्ण गुनासो",
      "icon": "done_all",
      "count": 25,
      "color": Color(0xFF2E7D32),
      "route": "/completed-complaints"
    },
  ];

  final List<Map<String, dynamic>> _suchanaBoard = [
    {
      "id": 1,
      "title": "सडक मर्मत कार्यक्रम सुरु",
      "description":
      "भद्रपुर नगरपालिकाको मुख्य सडकहरूको मर्मत कार्य यस साताबाट सुरु हुने भएको छ।",
      "category": "सूचना",
      "author": "नगर प्रमुख कार्यालय",
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "image":
      "https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=400&h=200&fit=crop"
    },
    {
      "id": 2,
      "title": "बिजुली काटिने सूचना",
      "description":
      "मर्मत कार्यका लागि भोलि बिहान ६ बजेदेखि १२ बजेसम्म बिजुली काटिने छ।",
      "category": "चेतावनी",
      "author": "विद्युत विभाग",
      "date": DateTime.now().subtract(Duration(hours: 5)),
      "image":
      "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=200&fit=crop"
    },
    {
      "id": 3,
      "title": "खानेपानी आपूर्ति सुधार",
      "description":
      "नयाँ पाइप लाइन जडानपछि खानेपानीको आपूर्तिमा सुधार आएको छ।",
      "category": "अपडेट",
      "author": "खानेपानी समिति",
      "date": DateTime.now().subtract(Duration(days: 1)),
      "image":
      "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=200&fit=crop"
    },
  ];


  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get exact screen dimensions using MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Calculate available space accounting for all UI elements
    final appBarHeight = 13.h; // Updated app bar height
    final bottomNavHeight = 12.h; // Fixed bottom nav height
    final safeAreaTop = mediaQuery.padding.top;
    final safeAreaBottom = mediaQuery.padding.bottom;

    // Available content area with extra buffer for safety
    final availableHeight = screenHeight - appBarHeight - bottomNavHeight - safeAreaTop - safeAreaBottom - 5.h;
    final availableWidth = screenWidth - 4.w;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: ProfileDrawer(userProfile: _userProfile),
      appBar: _buildAppBar(),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: availableHeight,
          maxWidth: availableWidth,
          minHeight: 0,
          minWidth: 0,
        ),
        child: OverflowBox(
          maxHeight: availableHeight,
          maxWidth: availableWidth,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildZeroOverflowHomeTab(availableHeight, availableWidth),
              _buildZeroOverflowComplaintsTab(availableHeight, availableWidth),
              _buildZeroOverflowProfileTab(availableHeight, availableWidth),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomTabBar(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(13.h.toDouble()), // Match the toolbar height
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent, // Make background transparent for gradient
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 0, // Remove default elevation since we have custom shadow
          toolbarHeight: 13.h,
          leading: GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 4.5.w,
                  backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
                  child: _userProfile['avatar'] != null
                      ? ClipOval(
                      child: CustomImageWidget(
                          imageUrl: _userProfile['avatar'] as String,
                          width: 9.w,
                          height: 9.w,
                          fit: BoxFit.cover))
                      : CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.5.w),
                ),
              ),
            ),
          ),
          title: _isSearching
              ? Container(
              height: 7.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      hintText: 'गुनासो खोज्नुहोस्...',
                      hintStyle: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.7),
                          fontSize: 13.sp),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
                        size: 5.w,
                      )),
                  onSubmitted: (value) => _performSearch(value)))
              : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'भद्रपुर नगरपालिका',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.3.h),
                Text(
                  'नागरिक सेवाहरू',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) _searchController.clear();
                  });
                },
                icon: CustomIconWidget(
                    iconName: _isSearching ? 'close' : 'search',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.5.w),
                padding: EdgeInsets.all(2.w),
                constraints: BoxConstraints(minWidth: 10.w, minHeight: 6.h),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () => _showNotifications(),
                      icon: CustomIconWidget(
                          iconName: 'notifications',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 5.5.w),
                      padding: EdgeInsets.all(2.w),
                      constraints: BoxConstraints(minWidth: 10.w, minHeight: 6.h)),
                  _notificationCount > 0
                      ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                          padding: EdgeInsets.all(0.3.w),
                          decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.onPrimary,
                                width: 1.5,
                              )),
                          constraints: BoxConstraints(minWidth: 5.w, minHeight: 5.w),
                          child: Text(
                            _notificationCount > 9 ? '9+' : '$_notificationCount',
                            style: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.onError,
                                fontSize: 7.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )))
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- Home Tab -------------------
  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - kBottomNavigationBarHeight - kToolbarHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showWelcomeBox) ...[
                    _buildZeroOverflowWelcomeSection(),
                    SizedBox(height: 3.h),
                  ],
                  _buildZeroOverflowComplaintCategoriesSection(),
                  SizedBox(height: 3.h),
                  _buildZeroOverflowSuchanaBoardSection(),
                  SizedBox(height: 2.h), // Reduced bottom spacing
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------- Zero Overflow Tab Builders -------------------
  Widget _buildZeroOverflowHomeTab(double availableHeight, double availableWidth) {
    return Container(
      height: availableHeight,
      width: availableWidth,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showWelcomeBox) ...[
              _buildZeroOverflowWelcomeSection(),
              SizedBox(height: 3.h),
            ],
            _buildZeroOverflowComplaintCategoriesSection(),
            SizedBox(height: 3.h),
            _buildZeroOverflowSuchanaBoardSection(),
            SizedBox(height: 8.h), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildZeroOverflowComplaintsTab(double availableHeight, double availableWidth) {
    return Container(
      height: availableHeight,
      width: availableWidth,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('मेरा गुनासोहरू',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 3.h),
            _buildZeroOverflowComplaintGrid(availableWidth),
            SizedBox(height: 8.h), // Extra space
          ],
        ),
      ),
    );
  }

  Widget _buildZeroOverflowComplaintGrid(double availableWidth) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Force 2 columns for all 4 categories
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.3, // Better aspect ratio
      ),
      itemCount: _complaintCategories.length,
      itemBuilder: (context, index) {
        final category = _complaintCategories[index];
        return ComplaintCategoryCard(
          title: category['title'] as String,
          iconName: category['icon'] as String,
          count: category['count'] as int,
          backgroundColor: category['color'] as Color,
          onTap: () => _navigateToCategory(category['route'] as String),
        );
      },
    );
  }

  Widget _buildZeroOverflowProfileTab(double availableHeight, double availableWidth) {
    return Container(
      height: availableHeight,
      width: availableWidth,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('प्रोफाइल',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 3.h),
            _buildZeroOverflowAvatarSection(),
            SizedBox(height: 3.h),
            _buildZeroOverflowProfileInfoCard(),
            SizedBox(height: 8.h), // Extra space
          ],
        ),
      ),
    );
  }

  Widget _buildZeroOverflowAvatarSection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: _userProfile['avatar'] != null
                    ? ClipOval(
                    child: CustomImageWidget(
                        imageUrl: _userProfile['avatar'] as String,
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover))
                    : CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w),
              ),
              if (_userProfile['isGoogleUser'] ?? false)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 3.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _userProfile['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_userProfile['isGoogleUser'] ?? false) ...[
                SizedBox(width: 0.5.w),
                CustomIconWidget(
                  iconName: 'verified',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 3.w,
                ),
              ],
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            _userProfile['email'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (_userProfile['isGoogleUser'] ?? false) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'google',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 3.w,
                  ),
                  SizedBox(width: 0.5.w),
                  Text(
                    'Google खाता',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildZeroOverflowProfileInfoCard() {
    final bool isGoogleUser = _userProfile['isGoogleUser'] ?? false;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'व्यक्तिगत जानकारी',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            if (isGoogleUser) ...[
              _buildZeroOverflowInfoRow('पूर्ण नाम', _userProfile['name'] as String, 'person'),
              _buildZeroOverflowInfoRow('पहिलो नाम', _userProfile['firstName'] as String, 'person_outline'),
              _buildZeroOverflowInfoRow('थर', _userProfile['lastName'] as String, 'person_outline'),
              _buildZeroOverflowInfoRow('Google ID', _userProfile['googleId'] as String, 'verified_user'),
            ],
            _buildZeroOverflowInfoRow('फोन नम्बर', _userProfile['phone'] as String, 'phone'),
            _buildZeroOverflowInfoRow('वार्ड नम्बर', 'वार्ड ${_userProfile['ward']}', 'location_city'),
            _buildZeroOverflowInfoRow('ठेगाना', _userProfile['address'] as String, 'home'),
            _buildZeroOverflowInfoRow('सदस्यता मिति', _formatDate(_userProfile['joinDate'] as DateTime), 'calendar_today'),
          ],
        ),
      ),
    );
  }

  Widget _buildZeroOverflowInfoRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- Complaint Tab -------------------
  Widget _buildComplaintsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('मेरा गुनासोहरू',
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.8,
            ),
            itemCount: _complaintCategories.length,
            itemBuilder: (context, index) {
              final category = _complaintCategories[index];
              return ComplaintCategoryCard(
                title: category['title'] as String,
                iconName: category['icon'] as String,
                count: category['count'] as int,
                backgroundColor: category['color'] as Color,
                onTap: () => _navigateToCategory(category['route'] as String),
              );
            },
          ),
        ],
      ),
    );
  }

  // ------------------- Profile Tab -------------------
  Widget _buildProfileTab() {
    final bool isGoogleUser = _userProfile['isGoogleUser'] ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - kBottomNavigationBarHeight - kToolbarHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('प्रोफाइल',
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 3.h),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 10.w, // Reduced size to prevent overflow
                            backgroundColor: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            child: _userProfile['avatar'] != null
                                ? ClipOval(
                                child: CustomImageWidget(
                                    imageUrl: _userProfile['avatar'] as String,
                                    width: 20.w,
                                    height: 20.w,
                                    fit: BoxFit.cover))
                                : CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 10.w),
                          ),
                          if (isGoogleUser)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(0.8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightTheme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'verified',
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                  size: 3.w,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _userProfile['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isGoogleUser) ...[
                            SizedBox(width: 1.w),
                            CustomIconWidget(
                              iconName: 'verified',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 4.w,
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _userProfile['email'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isGoogleUser) ...[
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'google',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Google खाता',
                                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                _buildProfileInfoCard(),
                SizedBox(height: 2.h), // Add bottom spacing
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------- Zero Overflow Helper Widgets -------------------
  Widget _buildZeroOverflowWelcomeSection() {
    final String firstName = _userProfile['firstName'] ?? _userProfile['name']?.split(' ')[0] ?? 'नागरिक';
    final bool isGoogleUser = _userProfile['isGoogleUser'] ?? false;

    return AnimatedOpacity(
      opacity: _showWelcomeBox ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isGoogleUser
                        ? 'स्वागत छ, $firstName! 🎉'
                        : 'स्वागत छ, $firstName!',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isGoogleUser)
                  CustomIconWidget(
                    iconName: 'verified',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
                isGoogleUser
                    ? 'तपाईंको Google खाता कनेक्ट भयो।'
                    : 'तपाईंको गुनासो महत्वपूर्ण छ।',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    height: 1.2,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 3.w),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    'वार्ड नम्बर ${_userProfile['ward']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZeroOverflowComplaintCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'गुनासो श्रेणीहरू',
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Force 2 columns for 4 items
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2, // Compact ratio for better fit
          ),
          itemCount: _complaintCategories.length,
          itemBuilder: (context, index) {
            final category = _complaintCategories[index];
            return ComplaintCategoryCard(
              title: category['title'] as String,
              iconName: category['icon'] as String,
              count: category['count'] as int,
              backgroundColor: category['color'] as Color,
              onTap: () => _navigateToCategory(category['route'] as String),
            );
          },
        ),
      ],
    );
  }

  Widget _buildZeroOverflowSuchanaBoardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'सूचना बोर्ड',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => print('View all notices'),
              child: Text(
                'सबै हेर्नुहोस्',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 18.h, // Fixed height for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(right: 4.w),
            itemCount: _suchanaBoard.length,
            itemBuilder: (context, index) {
              return Container(
                width: 65.w, // Fixed width for each card
                margin: EdgeInsets.only(right: 3.w),
                child: SuchanaBoardCard(notice: _suchanaBoard[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
    final bool isGoogleUser = _userProfile['isGoogleUser'] ?? false;
    final infoItems = isGoogleUser ? 8 : 4; // Number of info rows
    final titleHeight = 4.h;
    final itemHeight = 3.h; // Height per info row
    final totalHeight = titleHeight + (infoItems * itemHeight) + 2.h; // Title + items + spacing

    return Card(
      child: SizedBox(
        height: totalHeight,
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: titleHeight,
                  child: Text(
                    'व्यक्तिगत जानकारी',
                    style: AppTheme.lightTheme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1.h),
                if (isGoogleUser) ...[
                  _buildInfoRow('पूर्ण नाम', _userProfile['name'] as String, 'person'),
                  _buildInfoRow('पहिलो नाम', _userProfile['firstName'] as String, 'person_outline'),
                  _buildInfoRow('थर', _userProfile['lastName'] as String, 'person_outline'),
                  _buildInfoRow('Google ID', _userProfile['googleId'] as String, 'verified_user'),
                ],
                _buildInfoRow('फोन नम्बर', _userProfile['phone'] as String, 'phone'),
                _buildInfoRow('वार्ड नम्बर', 'वार्ड ${_userProfile['ward']}', 'location_city'),
                _buildInfoRow('ठेगाना', _userProfile['address'] as String, 'home'),
                _buildInfoRow('सदस्यता मिति', _formatDate(_userProfile['joinDate'] as DateTime), 'calendar_today'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    return SizedBox(
      height: 3.h, // Fixed height for each row
      child: Row(
        children: [
          SizedBox(
            width: 6.w,
            child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(value,
                    style: AppTheme.lightTheme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 12.h, // Limit height to prevent overflow
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor:
        AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicator: const BoxDecoration(),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        tabs: const [
          Tab(icon: Icon(Icons.home, size: 24)),
          Tab(icon: Icon(Icons.assignment, size: 24)),
          Tab(icon: Icon(Icons.person, size: 24)),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox(
      width: 14.w, // Constrain FAB size
      height: 14.w,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GunasoForm()));
        },
        child: Icon(Icons.add, size: 6.w), // Smaller icon
      ),
    );
  }

  // ------------------- Navigation -------------------
  void _navigateToCategory(String route) {
    switch (route) {
      case "/my-complaints":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MyComplaintPage()));
        break;
      case "/pending-work":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => PendingWorkPage()));
        break;
      case "/under-review":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => UnderReviewPage()));
        break;
      case "/completed-complaints":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => CompletedComplaintsPage()));
        break;
    }
  }

  // ------------------- Utilities -------------------
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _performSearch(String value) {
    print('Searching: $value');
  }

  void _showNotifications() {
    print('Notifications clicked');
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
