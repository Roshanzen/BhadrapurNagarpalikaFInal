import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';

class PendingWorkPage extends StatefulWidget {
  const PendingWorkPage({super.key});

  @override
  State<PendingWorkPage> createState() => _PendingWorkPageState();
}

class _PendingWorkPageState extends State<PendingWorkPage> {
  bool _isLoading = false;
  List _complaints = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPendingComplaints();
  }

  Future<void> _fetchPendingComplaints() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final memberId = prefs.getString('memberId') ?? '';

      if (memberId.isEmpty || memberId == 'null') {
        setState(() {
          _error = "Demo Mode: No pending complaints available.";
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(Uri.parse(
          "https://gwp.nirc.com.np:8443/GWP/message/getGunashoByMemberId?memberId=$memberId"));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        // Filter for pending/in-progress complaints
        final pendingComplaints = data.where((item) =>
            item['status'] == 'बाँकी' || item['status'] == 'काम भैरहेको').toList();

        final transformedData = pendingComplaints.map((item) => {
          'heading': item['heading'] ?? 'No Title',
          'message': item['message'] ?? 'No Message',
          'status': item['status'] ?? 'बाँकी',
          'createdDate': item['createdDate'] ?? DateTime.now().toString(),
          'id': item['id']?.toString() ?? 'N/A',
          'priority': item['priority'] ?? 'मध्यम'
        }).toList();

        setState(() {
          _complaints = transformedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Failed to fetch complaints: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        title: Text(
          'काम भैरहेको गुनासो',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'error',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _error!,
                          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : _complaints.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'work',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 12.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'कुनै पनि काम भैरहेको गुनासो छैन।',
                              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'तपाईंको सबै गुनासोहरू पूरा भएका छन्।',
                              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchPendingComplaints,
                      child: ListView.builder(
                        padding: EdgeInsets.all(4.w),
                        itemCount: _complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = _complaints[index];
                          return _buildComplaintCard(complaint, index);
                        },
                      ),
                    ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint, int index) {
    final priorityColors = {
      'उच्च': AppTheme.lightTheme.colorScheme.error,
      'मध्यम': AppTheme.lightTheme.colorScheme.secondary,
      'न्यून': Color(0xFF2E7D32),
    };

    final priorityColor = priorityColors[complaint['priority']] ?? AppTheme.lightTheme.colorScheme.secondary;

    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
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
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with priority and status
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    complaint['priority'] ?? 'मध्यम',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    complaint['status'] ?? 'बाँकी',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.w),
            // Title
            Text(
              complaint['heading'] ?? 'No Title',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.w),
            // Message
            Text(
              complaint['message'] ?? 'No Message',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.w),
            // Date and ID
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  _formatDate(complaint['createdDate'] ?? ''),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${complaint['id']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
