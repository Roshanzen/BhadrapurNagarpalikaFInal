import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/recent_complaint_card.dart';

class GunasoPage extends StatefulWidget {
  const GunasoPage({super.key});

  @override
  State<GunasoPage> createState() => _GunasoPageState();
}

class _GunasoPageState extends State<GunasoPage> {
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all'; // all, pending, resolved, in_progress
  String _selectedLanguage = 'ne'; // Default to Nepali

  // Mock complaints data - in real app, this would be fetched from API
  final List<Map<String, dynamic>> _allComplaints = [
    {
      "id": "C001",
      "title": "सडक बत्ती बिग्रिएको",
      "citizenName": "श्याम कुमार राई",
      "submissionDate": "२०८१/०५/०७",
      "priority": "उच्च",
      "status": "बाँकी",
      "ward": 5,
      "category": "पूर्वाधार",
      "description": "मुख्य सडकको बत्ती बिग्रिएको छ।",
      "phone": "+977-9841234567"
    },
    {
      "id": "C002",
      "title": "पानीको ट्याङ्की सफाई",
      "citizenName": "गीता देवी पौडेल",
      "submissionDate": "२०८१/०५/०६",
      "priority": "मध्यम",
      "status": "प्रगतिमा",
      "ward": 3,
      "category": "सफाई",
      "description": "पानीको ट्याङ्की सफाई गर्न आवश्यक छ।",
      "phone": "+977-9841234568"
    },
    {
      "id": "C003",
      "title": "कुकुर नियन्त्रण",
      "citizenName": "हरि प्रसाद अधिकारी",
      "submissionDate": "२०८१/०५/०५",
      "priority": "न्यून",
      "status": "सम्पन्न",
      "ward": 8,
      "category": "स्वास्थ्य",
      "description": "छिमेकमा कुकुरहरूले समस्या सिर्जना गरिरहेका छन्।",
      "phone": "+977-9841234569"
    },
    {
      "id": "C004",
      "title": "फोहोर संकलन समस्या",
      "citizenName": "सुनिता गुरुङ",
      "submissionDate": "२०८१/०५/०४",
      "priority": "उच्च",
      "status": "बाँकी",
      "ward": 12,
      "category": "सफाई",
      "description": "फोहोर संकलन समयमा हुँदैन।",
      "phone": "+977-9841234570"
    },
    {
      "id": "C005",
      "title": "सडक मर्मत",
      "citizenName": "राजेश थापा",
      "submissionDate": "२०८१/०५/०३",
      "priority": "मध्यम",
      "status": "प्रगतिमा",
      "ward": 7,
      "category": "पूर्वाधार",
      "description": "सडकमा धेरै खाल्डाखुल्डी छन्।",
      "phone": "+977-9841234571"
    }
  ];

  List<Map<String, dynamic>> get _filteredComplaints {
    List<Map<String, dynamic>> filtered = _allComplaints;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((complaint) {
        return complaint['title']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            complaint['citizenName']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            complaint['category']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((complaint) {
        switch (_selectedFilter) {
          case 'pending':
            return complaint['status'] == 'बाँकी';
          case 'in_progress':
            return complaint['status'] == 'प्रगतिमा';
          case 'resolved':
            return complaint['status'] == 'सम्पन्न';
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
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

  void _onFilterChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilter = value;
      });
    }
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('गुनासोहरू अपडेट गरियो'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
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
                  _showComplaintDetails(complaint);
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
                  _showStatusUpdateDialog(complaint);
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
                  _contactCitizen(complaint);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showComplaintDetails(Map<String, dynamic> complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('गुनासो #${complaint["id"]}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('शीर्षक: ${complaint["title"]}'),
                SizedBox(height: 1.h),
                Text('नागरिक: ${complaint["citizenName"]}'),
                SizedBox(height: 1.h),
                Text('वडा: ${complaint["ward"]}'),
                SizedBox(height: 1.h),
                Text('श्रेणी: ${complaint["category"]}'),
                SizedBox(height: 1.h),
                Text('प्राथमिकता: ${complaint["priority"]}'),
                SizedBox(height: 1.h),
                Text('स्थिति: ${complaint["status"]}'),
                SizedBox(height: 1.h),
                Text('फोन: ${complaint["phone"]}'),
                SizedBox(height: 1.h),
                Text('विवरण: ${complaint["description"]}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('बन्द गर्नुहोस्'),
            ),
          ],
        );
      },
    );
  }

  void _showStatusUpdateDialog(Map<String, dynamic> complaint) {
    String selectedStatus = complaint["status"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('स्थिति अपडेट गर्नुहोस्'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('बाँकी'),
                leading: Radio<String>(
                  value: 'बाँकी',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                ),
              ),
              ListTile(
                title: const Text('प्रगतिमा'),
                leading: Radio<String>(
                  value: 'प्रगतिमा',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                ),
              ),
              ListTile(
                title: const Text('सम्पन्न'),
                leading: Radio<String>(
                  value: 'सम्पन्न',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('रद्द गर्नुहोस्'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update complaint status
                setState(() {
                  complaint["status"] = selectedStatus;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('स्थिति अपडेट गरियो'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                );
              },
              child: const Text('अपडेट गर्नुहोस्'),
            ),
          ],
        );
      },
    );
  }

  void _contactCitizen(Map<String, dynamic> complaint) {
    // In real app, this would open phone dialer or messaging app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${complaint["phone"]} मा सम्पर्क गर्दै...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
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
                  hintText: LanguageManager.getString('search_complaints', _selectedLanguage),
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.7),
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              )
            : Text(LanguageManager.getString('complaint_management', _selectedLanguage)),
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
              size: 24,
            ),
            onPressed: _toggleSearch,
          ),
          PopupMenuButton<String>(
            onSelected: _onFilterChanged,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'all',
                  child: Text(LanguageManager.getString('all', _selectedLanguage)),
                ),
                PopupMenuItem<String>(
                  value: 'pending',
                  child: Text(LanguageManager.getString('pending', _selectedLanguage)),
                ),
                PopupMenuItem<String>(
                  value: 'in_progress',
                  child: Text(LanguageManager.getString('in_progress', _selectedLanguage)),
                ),
                PopupMenuItem<String>(
                  value: 'resolved',
                  child: Text(LanguageManager.getString('resolved', _selectedLanguage)),
                ),
              ];
            },
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    LanguageManager.getString('loading_data', _selectedLanguage),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : _filteredComplaints.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'inbox',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchQuery.isNotEmpty
                            ? LanguageManager.getString('no_search_results', _selectedLanguage)
                            : LanguageManager.getString('no_complaints', _selectedLanguage),
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshComplaints,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _filteredComplaints.length,
                    itemBuilder: (context, index) {
                      final complaint = _filteredComplaints[index];
                      return RecentComplaintCard(
                        complaintId: complaint["id"] as String,
                        title: complaint["title"] as String,
                        citizenName: complaint["citizenName"] as String,
                        submissionDate: complaint["submissionDate"] as String,
                        priority: complaint["priority"] as String,
                        status: complaint["status"] as String,
                        onTap: () {
                          _showComplaintDetails(complaint);
                        },
                        onLongPress: () {
                          _showComplaintActions(complaint);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}