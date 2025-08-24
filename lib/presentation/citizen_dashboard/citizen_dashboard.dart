import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/complaint_category_card.dart';
import './widgets/profile_drawer.dart';
import './widgets/suchana_board_card.dart';
import '../gunaso_form/gunaso_form.dart';

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({Key? key}) : super(key: key);

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

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "name": "राम बहादुर श्रेष्ठ",
    "email": "ram.shrestha@gmail.com",
    "phone": "+977-9841234567",
    "ward": 5,
    "address": "भद्रपुर-५, झापा",
    "avatar":
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "joinDate": DateTime.now().subtract(Duration(days: 180)),
  };

  // Mock complaint categories data
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

  // Mock Suchana Board data
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: ProfileDrawer(userProfile: _userProfile),
      appBar: _buildAppBar(),
      body: TabBarView(controller: _tabController, children: [
        _buildHomeTab(),
        _buildComplaintsTab(),
        _buildProfileTab(),
      ]),
      bottomNavigationBar: _buildBottomTabBar(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 2,
      leading: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: CircleAvatar(
            backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            child: _userProfile['avatar'] != null
                ? ClipOval(
                child: CustomImageWidget(
                    imageUrl: _userProfile['avatar'] as String,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover))
                : CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w),
          ),
        ),
      ),
      title: _isSearching
          ? TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontSize: 14.sp),
          decoration: InputDecoration(
              hintText: 'गुनासो वा सूचना खोज्नुहोस्...',
              hintStyle: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withOpacity(0.7),
                  fontSize: 14.sp),
              border: InputBorder.none),
          onSubmitted: (value) => _performSearch(value))
          : Text('भद्रपुर नगरपालिका',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
            icon: CustomIconWidget(
                iconName: _isSearching ? 'close' : 'search',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w)),
        Stack(children: [
          IconButton(
              onPressed: () => _showNotifications(),
              icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w)),
          _notificationCount > 0
              ? Positioned(
              right: 8,
              top: 8,
              child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10)),
                  constraints:
                  BoxConstraints(minWidth: 5.w, minHeight: 5.w),
                  child: Text(
                      _notificationCount > 9
                          ? '9+'
                          : _notificationCount.toString(),
                      style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onError,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)))
              : const SizedBox.shrink(),
        ]),
        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 3.h),
            _buildComplaintCategoriesSection(),
            SizedBox(height: 3.h),
            _buildSuchanaBoardSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
            AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('स्वागत छ, ${_userProfile['name']?.split(' ')[0] ?? 'नागरिक'}!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary)),
          SizedBox(height: 1.h),
          Text(
              'तपाईंको गुनासो र सुझावहरू हाम्रो लागि महत्वपूर्ण छ। सेवामा सुधार ल्याउन हामी प्रतिबद्ध छौं।',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 2.h),
          Row(children: [
            CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w),
            SizedBox(width: 2.w),
            Text('वार्ड नम्बर ${_userProfile['ward']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.primary)),
          ]),
        ],
      ),
    );
  }

  Widget _buildComplaintCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('गुनासो श्रेणीहरू',
            style: AppTheme.lightTheme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 2.h),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 1.8),
            itemCount: _complaintCategories.length,
            itemBuilder: (context, index) {
              final category = _complaintCategories[index];
              return ComplaintCategoryCard(
                  title: category['title'] as String,
                  iconName: category['icon'] as String,
                  count: category['count'] as int,
                  backgroundColor: category['color'] as Color,
                  onTap: () => _navigateToCategory(category['route'] as String));
            }),
      ],
    );
  }

  Widget _buildSuchanaBoardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('सूचना बोर्ड',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          TextButton(
              onPressed: () => _viewAllNotices(),
              child: Text('सबै हेर्नुहोस्',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500))),
        ]),
        SizedBox(height: 1.h),
        SizedBox(
            height: 25.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _suchanaBoard.length,
                itemBuilder: (context, index) {
                  return SuchanaBoardCard(notice: _suchanaBoard[index]);
                })),
      ],
    );
  }

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
                  childAspectRatio: 1.8),
              itemCount: _complaintCategories.length,
              itemBuilder: (context, index) {
                final category = _complaintCategories[index];
                return ComplaintCategoryCard(
                    title: category['title'] as String,
                    iconName: category['icon'] as String,
                    count: category['count'] as int,
                    backgroundColor: category['color'] as Color,
                    onTap: () =>
                        _navigateToCategory(category['route'] as String));
              }),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('प्रोफाइल',
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 3.h),
          Center(
              child: Column(children: [
                CircleAvatar(
                    radius: 12.w,
                    backgroundColor:
                    AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                    child: _userProfile['avatar'] != null
                        ? ClipOval(
                        child: CustomImageWidget(
                            imageUrl: _userProfile['avatar'] as String,
                            width: 24.w,
                            height: 24.w,
                            fit: BoxFit.cover))
                        : CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 12.w)),
                SizedBox(height: 2.h),
                Text(_userProfile['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(_userProfile['email'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              ])),
          SizedBox(height: 4.h),
          _buildProfileInfoCard(),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('व्यक्तिगत जानकारी',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 2.h),
            _buildInfoRow(
                'फोन नम्बर', _userProfile['phone'] as String, 'phone'),
            _buildInfoRow('वार्ड नम्बर', 'वार्ड ${_userProfile['ward']}',
                'location_city'),
            _buildInfoRow(
                'ठेगाना', _userProfile['address'] as String, 'home'),
            _buildInfoRow(
                'सदस्यता मिति',
                _formatDate(_userProfile['joinDate'] as DateTime),
                'calendar_today'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w),
          SizedBox(width: 4.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                            color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
                    Text(value,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ])),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2)),
          ],
        ),
        child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedLabelColor:
            AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            indicatorColor: AppTheme.lightTheme.colorScheme.primary,
            labelStyle: AppTheme.lightTheme.textTheme.labelSmall
                ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500),
            unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall
                ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
            tabs: [
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'home',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  text: 'गृह'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'assignment',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  text: 'गुनासो'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'person',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w),
                  text: 'प्रोफाइल'),
            ]),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GunasoForm()),
        );
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 6.w,
      ),
      label: Text(
        'गुनासो दर्ता',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Simulate data refresh
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // Implement search functionality
      print('Searching for: $query');
    }
  }

  void _showNotifications() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('सूचनाहरू',
                  style: AppTheme.lightTheme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              Text('कुनै नयाँ सूचना छैन',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              SizedBox(height: 4.h),
            ])));
  }

  void _navigateToCategory(String route) {
    // Navigate to specific complaint category
    print('Navigating to: $route');
  }

  void _viewAllNotices() {
    // Navigate to all notices screen
    print('View all notices');
  }

  void _submitComplaint() {
    // Navigate to complaint submission form
    print('Submit new complaint');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

