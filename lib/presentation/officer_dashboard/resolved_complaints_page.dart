import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/recent_complaint_card.dart';

class ResolvedComplaintsPage extends StatefulWidget {
  const ResolvedComplaintsPage({super.key});

  @override
  State<ResolvedComplaintsPage> createState() => _ResolvedComplaintsPageState();
}

class _ResolvedComplaintsPageState extends State<ResolvedComplaintsPage> {
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final String _selectedLanguage = 'ne'; // Default to Nepali

  // Mock resolved complaints data
  final List<Map<String, dynamic>> _resolvedComplaints = [
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
      "phone": "+977-9841234569",
      "resolutionDate": "२०८१/०५/१०",
      "resolution": "स्थानीय कुकुर नियन्त्रण टोलीले समस्या समाधान गरेको छ।"
    },
    {
      "id": "C007",
      "title": "बिजुलीको तार मर्मत",
      "citizenName": "सुरेश कुमार श्रेष्ठ",
      "submissionDate": "२०८१/०५/०२",
      "priority": "उच्च",
      "status": "सम्पन्न",
      "ward": 4,
      "category": "पूर्वाधार",
      "description": "घर नजिकैको बिजुलीको तार झुन्डिएको छ।",
      "phone": "+977-9841234573",
      "resolutionDate": "२०८१/०५/०८",
      "resolution": "नेपाल विद्युत प्राधिकरणले तार मर्मत गरेको छ।"
    },
    {
      "id": "C008",
      "title": "सडक बत्ती मर्मत",
      "citizenName": "माया देवी राई",
      "submissionDate": "२०८१/०४/३०",
      "priority": "मध्यम",
      "status": "सम्पन्न",
      "ward": 6,
      "category": "पूर्वाधार",
      "description": "सडकको बत्ती बिग्रिएको छ।",
      "phone": "+977-9841234574",
      "resolutionDate": "२०८१/०५/०५",
      "resolution": "नगरपालिकाको टोलीले बत्ती मर्मत गरेको छ।"
    }
  ];

  List<Map<String, dynamic>> get _filteredComplaints {
    if (_searchQuery.isEmpty) {
      return _resolvedComplaints;
    }
    return _resolvedComplaints.where((complaint) {
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

  void _showComplaintDetails(Map<String, dynamic> complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('गुनासो #${complaint["id"]} - सम्पन्न'),
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
                SizedBox(height: 2.h),
                const Text('समाधान विवरण:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 1.h),
                Text('समाधान मिति: ${complaint["resolutionDate"]}'),
                SizedBox(height: 1.h),
                Text('${complaint["resolution"]}'),
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
            : Text(LanguageManager.getString('resolved_complaints', _selectedLanguage)),
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
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchQuery.isNotEmpty
                            ? LanguageManager.getString('no_search_results', _selectedLanguage)
                            : LanguageManager.getString('no_resolved_complaints', _selectedLanguage),
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
                          // No actions for resolved complaints
                        },
                      );
                    },
                  ),
                ),
    );
  }
}