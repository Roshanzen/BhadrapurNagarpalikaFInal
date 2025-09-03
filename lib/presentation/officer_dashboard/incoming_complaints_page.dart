import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/recent_complaint_card.dart';
import '../gunaso_form/gunaso_form.dart'; // For GunasoStorage

class IncomingComplaintsPage extends StatefulWidget {
  const IncomingComplaintsPage({super.key});

  @override
  State<IncomingComplaintsPage> createState() => _IncomingComplaintsPageState();
}

class _IncomingComplaintsPageState extends State<IncomingComplaintsPage> {
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final String _selectedLanguage = 'ne'; // Default to Nepali

  // Dynamic incoming complaints data
  List<Map<String, dynamic>> _incomingComplaints = [];
  List<Map<String, dynamic>> _allComplaints = [];

  // Mock incoming complaints data (fallback)
  final List<Map<String, dynamic>> _mockComplaints = [
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
      "id": "C006",
      "title": "पानीको पाइप लिक",
      "citizenName": "बिना थापा",
      "submissionDate": "२०८१/०५/०३",
      "priority": "मध्यम",
      "status": "बाँकी",
      "ward": 7,
      "category": "पूर्वाधार",
      "description": "मुख्य पाइपबाट पानी चुहिरहेको छ।",
      "phone": "+977-9841234572"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> apiComplaints = [];
    List<Map<String, dynamic>> localComplaints = [];

    try {
      // Try to fetch from API first
      final response = await http.get(Uri.parse(
          "https://uat.nirc.com.np:8443/GWP/message/getAllGunasho"));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        apiComplaints = data.map((item) => {
          "id": item['id']?.toString() ?? 'N/A',
          "title": item['heading'] ?? 'No Title',
          "citizenName": item['fullName'] ?? 'Unknown',
          "submissionDate": _formatDate(item['createdDate']),
          "priority": item['priority'] ?? 'Medium',
          "status": item['status'] ?? 'Pending',
          "ward": item['ward'] ?? 1,
          "category": item['category'] ?? 'General',
          "description": item['message'] ?? 'No description',
          "phone": item['phoneNumber'] ?? 'N/A'
        }).toList();
      }
    } catch (e) {
      print('Error loading API complaints: $e');
    }

    try {
      // Load locally submitted gunasos
      localComplaints = await GunasoStorage.getGunasos();
      // Transform local data to match the expected format
      localComplaints = localComplaints.map((item) => {
        "id": item['id']?.toString() ?? 'N/A',
        "title": item['heading'] ?? 'No Title',
        "citizenName": item['fullName'] ?? 'Unknown',
        "submissionDate": _formatDate(item['createdDate']),
        "priority": item['priority'] ?? 'मध्यम',
        "status": item['status'] ?? 'बाँकी',
        "ward": item['ward'] ?? 1,
        "category": item['category'] ?? 'सामान्य',
        "description": item['message'] ?? 'No description',
        "phone": item['phoneNumber'] ?? 'N/A'
      }).toList();
    } catch (e) {
      print('Error loading local complaints: $e');
    }

    // Combine API and local complaints
    final allComplaints = [...apiComplaints, ...localComplaints, ..._mockComplaints];

    setState(() {
      _incomingComplaints = allComplaints;
      _allComplaints = List.from(allComplaints);
      _isLoading = false;
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return DateTime.now().toString().split(' ')[0];
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return DateTime.now().toString().split(' ')[0];
    }
  }

  List<Map<String, dynamic>> get _filteredComplaints {
    if (_searchQuery.isEmpty) {
      return _incomingComplaints;
    }
    return _incomingComplaints.where((complaint) {
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
            : Text(LanguageManager.getString('incoming_complaints', _selectedLanguage)),
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
                            : LanguageManager.getString('no_incoming_complaints', _selectedLanguage),
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