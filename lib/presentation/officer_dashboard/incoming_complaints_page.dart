import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/browser_client.dart' if (dart.library.io) 'package:http/io_client.dart' as http_client;
import 'package:universal_html/html.dart' as html;
import 'dart:io' show Platform;

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import '../../services/officer_api_service.dart';
import './widgets/recent_complaint_card.dart';
import '../gunaso_form/gunaso_form.dart'; // For GunasoStorage

class IncomingComplaintsPage extends StatefulWidget {
  const IncomingComplaintsPage({super.key});

  @override
  State<IncomingComplaintsPage> createState() => _IncomingComplaintsPageState();
}

class _IncomingComplaintsPageState extends State<IncomingComplaintsPage> {
  bool _isLoading = false;
  final String _selectedLanguage = 'ne'; // Default to Nepali

  // Dynamic incoming complaints data (only from API)
  List<Map<String, dynamic>> _incomingComplaints = [];
  List<Map<String, dynamic>> _allComplaints = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('officer_logged_in') ?? false;

    if (!isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/officer-login-screen');
      }
      return;
    }

    _loadComplaints();
  }


  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
    });

    // Check if officer is logged in
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('officer_logged_in') ?? false;

    if (!isLoggedIn) {
      print('Officer not logged in - redirecting to login');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/officer-login-screen');
      }
      return;
    }

    List<Map<String, dynamic>> apiComplaints = [];
    List<Map<String, dynamic>> localComplaints = [];

    try {
      // Use OfficerApiService which handles cookies and session persistence
      apiComplaints = await OfficerApiService.getGunasoList(
        offset: 0,
        limit: 50,
      );
    } catch (e) {
      print('Error loading API complaints: $e');
      // If authentication error, redirect to login
      if (e.toString().contains('Authentication required')) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/officer-login-screen');
        }
      }
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

    // Combine API and local complaints (no mock data)
    final allComplaints = [...apiComplaints, ...localComplaints];

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
    return _incomingComplaints;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _logout() async {
    // Use OfficerApiService to properly clear cookies and session
    await OfficerApiService.logout();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/officer-login-screen');
    }
  }

  Future<void> _refreshComplaints() async {
    // Actually refresh from API instead of just simulating
    await _loadComplaints();

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
        title: Text(LanguageManager.getString('incoming_complaints', _selectedLanguage)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/officer-dashboard');
          },
        ),
        actions: [],
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
                        LanguageManager.getString('no_incoming_complaints', _selectedLanguage),
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
