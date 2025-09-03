import '../gunaso_form/gunaso_form.dart';
import '../gunaso_form/widgets/my_complaint_page.dart';
import '../gunaso_form/widgets/pending_work_page.dart';
import '../gunaso_form/widgets/under_review_page.dart';
import '../gunaso_form/widgets/completed_complaints_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../services/language_service.dart';
import '../../services/notification_service.dart';
import './widgets/complaint_category_card.dart';
import './widgets/profile_drawer.dart';
import './widgets/suchana_board_card.dart';
import '../notifications_page.dart';
import '../suchana_board_details_page.dart';

class CitizenDashboard extends StatefulWidget {
  final Map<String, dynamic>? googleUserData;

  const CitizenDashboard({super.key, this.googleUserData});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _notificationCount = 0;
  bool _showWelcomeBox = true;

  late Map<String, dynamic> _userProfile;
  late LanguageService _languageService;
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _languageService = LanguageService();
    _notificationService = NotificationService();

    // Listen to language changes
    _languageService.addListener(_onLanguageChanged);
    // Listen to notification changes
    _notificationService.addListener(_onNotificationChanged);

    _initializeServices();

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
      _userProfile = {
        "name": widget.googleUserData!['displayName'] ?? widget.googleUserData!['fullName'] ?? 'नागरिक',
        "email": widget.googleUserData!['email'] ?? '',
        "phone": "+977-XXXXXXXXXX",
        "ward": 1,
        "address": "भद्रपुर नगरपालिका",
        "avatar": widget.googleUserData!['photoUrl'] ?? widget.googleUserData!['picture'] ?? null,
        "joinDate": DateTime.now(),
        "isGoogleUser": true,
        "googleId": widget.googleUserData!['localId'] ?? '',
        "firstName": widget.googleUserData!['firstName'] ?? '',
        "lastName": widget.googleUserData!['lastName'] ?? '',
      };
    } else {
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

  Future<void> _initializeServices() async {
    await _notificationService.initialize();
    _initializeUserProfile();
  }

  void _onNotificationChanged() {
    if (mounted) {
      setState(() {
        _notificationCount = _notificationService.unreadCount;
      });
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
      "description": "भद्रपुर नगरपालिकाको मुख्य सडकहरूको मर्मत कार्य यस साताबाट सुरु हुने भएको छ।",
      "category": "सूचना",
      "author": "नगर प्रमुख कार्यालय",
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "image": "https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=400&h=200&fit=crop"
    },
    {
      "id": 2,
      "title": "बिजुली काटिने सूचना",
      "description": "मर्मत कार्यका लागि भोलि बिहान ६ बजेदेखि १२ बजेसम्म बिजुली काटिने छ।",
      "category": "चेतावनी",
      "author": "विद्युत विभाग",
      "date": DateTime.now().subtract(Duration(hours: 5)),
      "image": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=200&fit=crop"
    },
    {
      "id": 3,
      "title": "खानेपानी आपूर्ति सुधार",
      "description": "नयाँ पाइप लाइन जडानपछि खानेपानीको आपूर्तिमा सुधार आएको छ।",
      "category": "अपडेट",
      "author": "खानेपानी समिति",
      "date": DateTime.now().subtract(Duration(days: 1)),
      "image": "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=200&fit=crop"
    },
  ];

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _languageService.removeListener(_onLanguageChanged);
    _notificationService.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    debugPrint('🏠 CitizenDashboard: Language change detected');
    if (mounted) {
      setState(() {
        debugPrint('✅ CitizenDashboard: UI rebuilt, current language: ${_languageService.currentLanguage}');
      });
    } else {
      debugPrint('⚠️ CitizenDashboard: Widget not mounted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      drawer: ProfileDrawer(userProfile: _userProfile),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildHomeTab(),
            _buildComplaintsTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(10.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withOpacity(0.9),
              AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Column(
              children: [
                // Top row with avatar and actions
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.15),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 4.w,
                          backgroundColor: Colors.transparent,
                          child: _userProfile['avatar'] != null
                              ? ClipOval(
                                  child: CustomImageWidget(
                                    imageUrl: _userProfile['avatar'] as String,
                                    width: 8.w,
                                    height: 8.w,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : CustomIconWidget(
                                  iconName: 'person',
                                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 4.w,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'नमस्ते, ${_userProfile['name']?.split(' ')[0] ?? 'नागरिक'}',
                            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            'वार्ड ${_userProfile['ward']} • भद्रपुर',
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.8),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.1),
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
                              size: 5.w,
                            ),
                            padding: EdgeInsets.all(2.w),
                            constraints: BoxConstraints(minWidth: 10.w, minHeight: 6.h),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                onPressed: _showNotifications,
                                icon: CustomIconWidget(
                                  iconName: 'notifications',
                                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 5.w,
                                ),
                                padding: EdgeInsets.all(2.w),
                                constraints: BoxConstraints(minWidth: 10.w, minHeight: 6.h),
                              ),
                              if (_notificationCount > 0)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: EdgeInsets.all(0.3.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme.error,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                                        width: 1.5,
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 4.w,
                                      minHeight: 4.w,
                                    ),
                                    child: Text(
                                      _notificationCount > 9 ? '9+' : '$_notificationCount',
                                      style: TextStyle(
                                        color: AppTheme.lightTheme.colorScheme.onError,
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field below appbar
            if (_isSearching)
              Container(
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'गुनासो खोज्नुहोस्...',
                    hintStyle: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      size: 5.w,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                        size: 5.w,
                      ),
                    ),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),
            if (_showWelcomeBox) ...[
              _buildWelcomeCard(),
              SizedBox(height: 3.h),
            ],
            _buildComplaintCategories(),
            SizedBox(height: 3.h),
            _buildSuchanaBoard(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'मेरा गुनासोहरू',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.h,
              childAspectRatio: 1.2,
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
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildProfileHeader(),
          SizedBox(height: 3.h),
          _buildProfileInfo(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final String firstName = _userProfile['firstName'] ?? _userProfile['name']?.split(' ')[0] ?? 'नागरिक';
    final bool isGoogleUser = _userProfile['isGoogleUser'] ?? false;

    return AnimatedOpacity(
      opacity: _showWelcomeBox ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _languageService.getString('welcome_message').replaceAll('{name}', firstName),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    isGoogleUser
                        ? _languageService.getString('google_account_connected')
                        : _languageService.getString('complaint_important'),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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


  Widget _buildComplaintCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'गुनासो श्रेणीहरू',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'सबै हेर्नुहोस्',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: _complaintCategories.length,
            itemBuilder: (context, index) {
              final category = _complaintCategories[index];
              return _buildModernComplaintCard(category, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernComplaintCard(Map<String, dynamic> category, int index) {
    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 4.w),
      child: GestureDetector(
        onTap: () => _navigateToCategory(category['route'] as String),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (category['color'] as Color).withOpacity(0.8),
                (category['color'] as Color).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (category['color'] as Color).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -2.w,
                bottom: -2.w,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon and count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: category['icon'] as String,
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${category['count']}',
                            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Title
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          category['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuchanaBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'सूचना बोर्ड',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: _showAllSuchanaNotices,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'सबै हेर्नुहोस्',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: _suchanaBoard.length,
            itemBuilder: (context, index) {
              return _buildModernSuchanaCard(_suchanaBoard[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernSuchanaCard(Map<String, dynamic> notice, int index) {
    final categoryColors = {
      'सूचना': AppTheme.lightTheme.colorScheme.primary,
      'चेतावनी': Color(0xFFF57C00),
      'अपडेट': Color(0xFF2E7D32),
    };

    final categoryColor = categoryColors[notice['category']] ?? AppTheme.lightTheme.colorScheme.primary;

    return GestureDetector(
      onTap: () => _showSuchanaNoticeDetails(notice),
      child: Container(
        width: 75.w,
        margin: EdgeInsets.only(right: 4.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Image section with overlay
            Container(
              height: 12.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(notice['image'] as String),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notice['category'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Time
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatTimeAgo(notice['date'] as DateTime),
                          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notice['title'] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Description
                    Expanded(
                      child: Text(
                        notice['description'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    // Author
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            notice['author'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}द';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}घ';
    } else {
      return '${difference.inMinutes}म';
    }
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.1),
                child: _userProfile['avatar'] != null
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: _userProfile['avatar'] as String,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 8.w,
                      ),
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
          SizedBox(height: 2.h),
          Text(
            _userProfile['name'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            _userProfile['email'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (_userProfile['isGoogleUser'] ?? false) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'google',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Google खाता',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
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

  Widget _buildProfileInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'व्यक्तिगत जानकारी',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInfoRow('फोन नम्बर', _userProfile['phone'] as String, 'phone'),
          _buildInfoRow('वार्ड नम्बर', 'वार्ड ${_userProfile['ward']}', 'location_city'),
          _buildInfoRow('ठेगाना', _userProfile['address'] as String, 'home'),
          _buildInfoRow('सदस्यता मिति', _formatDate(_userProfile['joinDate'] as DateTime), 'calendar_today'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(1.5.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (index) {
            setState(() {
              _tabController.animateTo(index);
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 11.sp,
          unselectedFontSize: 10.sp,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          items: [
            _buildNavItem(
              Icons.home_outlined,
              Icons.home,
              _languageService.getString('home'),
              _tabController.index == 0,
            ),
            _buildNavItem(
              Icons.assignment_outlined,
              Icons.assignment,
              _languageService.getString('complaints'),
              _tabController.index == 1,
            ),
            _buildNavItem(
              Icons.person_outline,
              Icons.person,
              _languageService.getString('profile'),
              _tabController.index == 2,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSelected ? 1.5.w : 1.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          size: isSelected ? 6.w : 5.w,
        ),
      ),
      activeIcon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(1.5.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          activeIcon,
          size: 6.w,
        ),
      ),
      label: label,
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GunasoForm()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.add,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
    );
  }

  void _navigateToCategory(String route) async {
    switch (route) {
      case "/my-complaints":
        final prefs = await SharedPreferences.getInstance();
        final memberId = prefs.getString('memberId') ?? '';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyComplaintPage(memberId: memberId)),
        );
        break;
      case "/pending-work":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PendingWorkPage()),
        );
        break;
      case "/under-review":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UnderReviewPage()),
        );
        break;
      case "/completed-complaints":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CompletedComplaintsPage()),
        );
        break;
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _performSearch(String value) {
    print('Searching: $value');
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsPage()),
    );
  }

  void _showAllSuchanaNotices() {
    // For now, show a simple dialog with all notices
    // In a real app, this would navigate to a dedicated Suchana Board page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'सूचना बोर्ड',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _suchanaBoard.length,
            itemBuilder: (context, index) {
              final notice = _suchanaBoard[index];
              return ListTile(
                title: Text(
                  notice['title'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  notice['description'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuchanaBoardDetailsPage(notice: notice),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'बन्द गर्नुहोस्',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuchanaNoticeDetails(Map<String, dynamic> notice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuchanaBoardDetailsPage(notice: notice),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
