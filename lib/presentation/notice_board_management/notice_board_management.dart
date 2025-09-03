import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/analytics_widget.dart';
import './widgets/notice_card_widget.dart';
import './widgets/notice_form_widget.dart';

class NoticeBoardManagement extends StatefulWidget {
  const NoticeBoardManagement({super.key});

  @override
  State<NoticeBoardManagement> createState() => _NoticeBoardManagementState();
}

class _NoticeBoardManagementState extends State<NoticeBoardManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final String _selectedLanguage = 'ne'; // Default to Nepali

  // Mock notices data
  final List<Map<String, dynamic>> _allNotices = [
    {
      "id": "N001",
      "title": "नगरपालिका सभाको सूचना",
      "excerpt":
      "आगामी २०८१/०५/१५ गते नगरपालिका सभा बस्ने भएकोले सम्पूर्ण नागरिकहरूलाई जानकारी गराइन्छ।",
      "content":
      "आदरणीय नागरिकहरू,\n\nआगामी २०८१/०५/१५ गते बिहान १० बजे नगरपालिका सभा बस्ने भएकोले सम्पूर्ण नागरिकहरूलाई जानकारी गराइन्छ। सभामा महत्वपूर्ण निर्णयहरू लिइने हुँदा सबैको उपस्थिति अनिवार्य छ।",
      "publicationDate": "२०८१/०५/०७",
      "status": "published",
      "thumbnailImage":
      "https://images.pexels.com/photos/8761412/pexels-photo-8761412.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "viewCount": 245,
      "targetAudience": "all",
      "author": "राम बहादुर श्रेष्ठ",
      "priority": "high",
      "scheduledDate": null,
      "ward": null
    },
    {
      "id": "N002",
      "title": "सफाई अभियान कार्यक्रम",
      "excerpt": "आगामी शुक्रबार वडा नं. ५ मा सफाई अभियान सञ्चालन हुने भएको छ।",
      "content":
      "प्रिय नागरिकहरू,\n\nआगामी शुक्रबार बिहान ७ बजेदेखि वडा नं. ५ मा सफाई अभियान सञ्चालन हुने भएको छ। सबै नागरिकहरूको सहयोग अपेक्षा गरिएको छ।",
      "publicationDate": "२०८१/०५/०६",
      "status": "published",
      "thumbnailImage":
      "https://images.pexels.com/photos/6230579/pexels-photo-6230579.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "viewCount": 128,
      "targetAudience": "ward",
      "author": "सीता पौडेल",
      "priority": "medium",
      "scheduledDate": null,
      "ward": 5
    },
    {
      "id": "N003",
      "title": "कर संकलन अभियान",
      "excerpt": "यो आर्थिक वर्षको कर संकलन अभियान सुरु भएको जानकारी।",
      "content":
      "सम्मानित नागरिकहरू,\n\nयो आर्थिक वर्षको कर संकलन अभियान सुरु भएको छ। समयमै कर तिर्न अनुरोध छ।",
      "publicationDate": null,
      "status": "draft",
      "thumbnailImage": null,
      "viewCount": 0,
      "targetAudience": "all",
      "author": "हरि अधिकारी",
      "priority": "medium",
      "scheduledDate": "२०८१/०५/१०",
      "ward": null
    }
  ];

  List<Map<String, dynamic>> get _filteredNotices {
    if (_searchQuery.isEmpty) {
      return _allNotices;
    }
    return _allNotices.where((notice) {
      return notice['title']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          notice['excerpt'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _publishedNotices {
    return _filteredNotices
        .where((notice) => notice['status'] == 'published')
        .toList();
  }

  List<Map<String, dynamic>> get _draftNotices {
    return _filteredNotices
        .where((notice) => notice['status'] == 'draft')
        .toList();
  }

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

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _showCreateNoticeForm({Map<String, dynamic>? notice}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => NoticeFormWidget(
            notice: notice,
            onSave: _handleNoticeCreate,
            onUpdate: _handleNoticeUpdate));
  }

  void _handleNoticeCreate(Map<String, dynamic> noticeData) {
    setState(() {
      _allNotices.insert(0, noticeData);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(noticeData['status'] == 'published'
            ? LanguageManager.getString('notice_published', _selectedLanguage)
            : LanguageManager.getString('notice_saved_draft', _selectedLanguage)),
        backgroundColor: AppTheme.successLight));
  }

  void _handleNoticeUpdate(Map<String, dynamic> updatedNotice) {
    setState(() {
      int index = _allNotices
          .indexWhere((notice) => notice['id'] == updatedNotice['id']);
      if (index != -1) {
        _allNotices[index] = updatedNotice;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(LanguageManager.getString('notice_updated', _selectedLanguage)),
        backgroundColor: AppTheme.successLight));
  }

  void _handleNoticeDelete(String noticeId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(LanguageManager.getString('delete_notice_confirm', _selectedLanguage)),
            content:
            Text(LanguageManager.getString('delete_notice_confirm', _selectedLanguage)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('रद्द गर्नुहोस्')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _allNotices.removeWhere(
                              (notice) => notice['id'] == noticeId);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(LanguageManager.getString('notice_deleted', _selectedLanguage)),
                        backgroundColor: AppTheme.errorLight));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorLight),
                  child: Text(LanguageManager.getString('delete', _selectedLanguage))),
            ]));
  }

  void _previewNotice(Map<String, dynamic> notice) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _NoticePreviewScreen(notice: notice)));
  }

  Widget _buildNoticesList(List<Map<String, dynamic>> notices) {
    if (notices.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomIconWidget(
                iconName: 'article',
                size: 64,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            SizedBox(height: 2.h),
            Text(
                _searchQuery.isNotEmpty
                    ? LanguageManager.getString('no_search_results', _selectedLanguage)
                    : LanguageManager.getString('no_notices', _selectedLanguage),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          ]));
    }

    return RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
            padding: EdgeInsets.all(2.w),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return NoticeCardWidget(
                  notice: notice,
                  onTap: () => _previewNotice(notice),
                  onEdit: () => _showCreateNoticeForm(notice: notice),
                  onDelete: () => _handleNoticeDelete(notice['id']));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: _isSearching
                ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: LanguageManager.getString('search_notices', _selectedLanguage),
                    border: InputBorder.none,
                    hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.7))),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary))
                : Text(LanguageManager.getString('notice_board_management', _selectedLanguage)),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/officer-dashboard');
              },
            ),
            actions: [
              IconButton(
                  icon: CustomIconWidget(
                      iconName: _isSearching ? 'close' : 'search',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24),
                  onPressed: _toggleSearch),
              SizedBox(width: 2.w),
            ],
            bottom: TabBar(
                controller: _tabController,
                labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                unselectedLabelColor: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.7),
                indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
                tabs: [
                  Tab(text: LanguageManager.getString('all_notices', _selectedLanguage)),
                  Tab(text: LanguageManager.getString('published', _selectedLanguage)),
                  Tab(text: LanguageManager.getString('draft', _selectedLanguage)),
                ])),
        body: _isLoading
            ? Center(
            child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary))
            : TabBarView(controller: _tabController, children: [
          _buildNoticesList(_filteredNotices),
          _buildNoticesList(_publishedNotices),
          _buildNoticesList(_draftNotices),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showCreateNoticeForm(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24),
            label: Text(LanguageManager.getString('add_notice', _selectedLanguage))));
  }
}

class _NoticePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> notice;

  const _NoticePreviewScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: const Text('सूचना पूर्वावलोकन'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Notice Header
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                                color: notice['status'] == 'published'
                                    ? AppTheme.successLight
                                    : AppTheme.warningLight,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                                notice['status'] == 'published'
                                    ? 'प्रकाशित'
                                    : 'ड्राफ्ट',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(height: 2.h),

                        // Title
                        Text(notice['title'],
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurface)),
                        SizedBox(height: 1.h),

                        // Meta Info
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'person',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant),
                          SizedBox(width: 1.w),
                          Text(notice['author'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                              iconName: 'calendar_today',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant),
                          SizedBox(width: 1.w),
                          Text(
                              notice['publicationDate'] ??
                                  'मिति सेट गरिएको छैन',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                        ]),
                      ])),

              SizedBox(height: 3.h),

              // Featured Image
              if (notice['thumbnailImage'] != null) ...[
                Container(
                    width: double.infinity,
                    height: 25.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2)),
                        ]),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(imageUrl: notice['thumbnailImage'], fit: BoxFit.cover))),
                SizedBox(height: 3.h),
              ],

              // Content
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Text(notice['content'],
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: AppTheme.lightTheme.colorScheme.onSurface))),

              SizedBox(height: 3.h),

              // Analytics (only for published notices)
              if (notice['status'] == 'published') ...[
                AnalyticsWidget(notice: notice),
                SizedBox(height: 3.h),
              ],

              // Target Audience Info
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'group',
                              size: 20,
                              color: AppTheme.lightTheme.colorScheme.primary),
                          SizedBox(width: 2.w),
                          Text('लक्षित दर्शक',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme
                                      .lightTheme.colorScheme.primary)),
                        ]),
                        SizedBox(height: 1.h),
                        Text(
                            notice['targetAudience'] == 'all'
                                ? 'सम्पूर्ण नागरिक'
                                : 'वडा नं. ${notice['ward']}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurface)),
                      ])),
            ])));
  }
}