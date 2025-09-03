import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/media_gallery_widget.dart';
import './widgets/status_timeline_widget.dart';

class ComplaintDetailView extends StatefulWidget {
  const ComplaintDetailView({super.key});

  @override
  State<ComplaintDetailView> createState() => _ComplaintDetailViewState();
}

class _ComplaintDetailViewState extends State<ComplaintDetailView> {
  String? _complaintId;
  bool _isOfficer = false;
  bool _isLoading = true;
  bool _isBookmarked = false;

  // Mock complaint data - in real app, this would come from API
  Map<String, dynamic>? _complaintData;
  List<StatusUpdate> _statusUpdates = [];
  List<MediaItem> _mediaItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _complaintId = args?['complaintId'] ?? 'CMP12345';
    _isOfficer = args?['isOfficer'] ?? false;
    _loadComplaintData();
  }

  Future<void> _loadComplaintData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      _complaintData = {
        'id': _complaintId,
        'title': 'सडकमा ठूलो खाडल / Large pothole on road',
        'description':
        'मेरो घर नजिकको सडकमा एउटा ठूलो खाडल छ जसले गर्दा दुर्घटना हुन सक्छ। कृपया यसलाई तत्काल मर्मत गर्नुहोस्।\n\nThere is a large pothole on the road near my house which can cause accidents. Please repair it immediately.',
        'status': 'प्रगतिमा / In Progress',
        'priority': 'उच्च / High',
        'category': 'सडक र यातायात / Roads & Transportation',
        'ward': 'वडा नम्बर ५ / Ward 5',
        'submittedBy': 'राम बहादुर श्रेष्ठ',
        'submittedDate': DateTime.now().subtract(const Duration(days: 3)),
        'location': '27.7172° N, 85.3240° E',
        'address': 'भद्रपुर नगरपालिका, वडा नम्बर ५, कमल चोक',
        'contactVisible': _isOfficer,
        'contactPhone': '+977 9841234567',
      };

      _statusUpdates = [
        StatusUpdate(
          id: '1',
          status: 'पेश गरियो / Submitted',
          message:
          'गुनासो सफलतापूर्वक पेश गरियो र प्रारम्भिक समीक्षाको लागि पठाइयो।\nComplaint successfully submitted and sent for initial review.',
          officerName: 'System',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
        StatusUpdate(
          id: '2',
          status: 'समीक्षा भयो / Reviewed',
          message:
          'गुनासोको समीक्षा गरियो र सम्बन्धित टोलीलाई जिम्मेवारी दिइयो।\nComplaint has been reviewed and assigned to relevant team.',
          officerName: 'अधिकारी रमेश कुमार',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        StatusUpdate(
          id: '3',
          status: 'प्रगतिमा / In Progress',
          message:
          'सडक मर्मत टोली स्थलगत अध्ययनको लागि पठाइएको छ। मर्मत कार्य भोलि सुरु हुनेछ।\nRoad repair team has been sent for site survey. Repair work will start tomorrow.',
          officerName: 'इन्जिनियर सुनिल राई',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          attachments: ['survey_report.pdf'],
        ),
      ];

      _mediaItems = [
        MediaItem(
          id: '1',
          url:
          'https://images.pexels.com/photos/1209978/pexels-photo-1209978.jpeg',
          type: 'image',
          caption: 'सडकमा रहेको खाडलको फोटो',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        MediaItem(
          id: '2',
          url:
          'https://images.pexels.com/photos/2680270/pexels-photo-2680270.jpeg',
          type: 'image',
          caption: 'नजिकबाट खिचेको फोटो',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        MediaItem(
          id: '3',
          url:
          'https://images.pexels.com/photos/416978/pexels-photo-416978.jpeg',
          type: 'video',
          caption: 'समस्याको भिडियो',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('डाटा लोड गर्न समस्या भयो / Error loading data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked
            ? 'बुकमार्क गरियो / Bookmarked'
            : 'बुकमार्क हटाइयो / Bookmark removed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _shareComplaint() {
    final complaintUrl = 'https://bhadrapur.gov.np/complaint/$_complaintId';
    Clipboard.setData(ClipboardData(text: complaintUrl));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('लिङ्क कपी गरियो / Link copied to clipboard'),
      ),
    );
  }

  void _showUpdateStatusDialog() {
    if (!_isOfficer) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const UpdateStatusModal(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('प्रगतिमा') || status.contains('Progress')) {
      return AppTheme.statusInProgress;
    } else if (status.contains('समाधान') || status.contains('Resolved')) {
      return AppTheme.statusCompleted;
    } else if (status.contains('अस्वीकृत') || status.contains('Rejected')) {
      return AppTheme.statusRejected;
    } else {
      return AppTheme.statusPending;
    }
  }

  Color _getPriorityColor(String priority) {
    if (priority.contains('उच्च') || priority.contains('High')) {
      return AppTheme.priorityHigh;
    } else if (priority.contains('मध्यम') || priority.contains('Medium')) {
      return AppTheme.priorityMedium;
    } else {
      return AppTheme.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('गुनासो विवरण / Complaint Details')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_complaintData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('गुनासो विवरण / Complaint Details')),
        body: const Center(
          child: Text('गुनासो फेला परेन / Complaint not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'गुनासो #${_complaintId?.substring(_complaintId!.length - 5)}'),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareComplaint,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadComplaintData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _complaintData!['title'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),

                  // Status and Priority badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_complaintData!['status'])
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getStatusColor(_complaintData!['status'])
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: _getStatusColor(_complaintData!['status']),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _complaintData!['status'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: _getStatusColor(
                                    _complaintData!['status']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(_complaintData!['priority'])
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                            _getPriorityColor(_complaintData!['priority'])
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 14,
                              color: _getPriorityColor(
                                  _complaintData!['priority']),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _complaintData!['priority'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: _getPriorityColor(
                                    _complaintData!['priority']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Submitted info
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _complaintData!['submittedBy'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_complaintData!['submittedDate'].day}/${_complaintData!['submittedDate'].month}/${_complaintData!['submittedDate'].year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  // Contact info (officers only)
                  if (_isOfficer && _complaintData!['contactVisible']) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Implement call functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text('Call functionality not implemented')),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _complaintData!['contactPhone'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'विस्तृत विवरण / Description',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _complaintData!['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Location section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'स्थान / Location',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_complaintData!['ward']}\n${_complaintData!['address']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GPS: ${_complaintData!['location']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Media gallery
            if (_mediaItems.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: MediaGalleryWidget(
                  mediaItems: _mediaItems,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Status timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: StatusTimelineWidget(
                updates: _statusUpdates,
                isOfficer: _isOfficer,
              ),
            ),
          ],
        ),
      ),

      // Floating action button for officers
      floatingActionButton: _isOfficer
          ? FloatingActionButton.extended(
        onPressed: _showUpdateStatusDialog,
        icon: const Icon(Icons.edit),
        label: const Text('अपडेट / Update'),
      )
          : null,
    );
  }
}

class UpdateStatusModal extends StatefulWidget {
  const UpdateStatusModal({super.key});

  @override
  State<UpdateStatusModal> createState() => _UpdateStatusModalState();
}

class _UpdateStatusModalState extends State<UpdateStatusModal> {
  final TextEditingController _responseController = TextEditingController();
  String? _selectedStatus;

  final List<String> _statuses = [
    'समीक्षा भयो / Reviewed',
    'प्रगतिमा / In Progress',
    'समाधान भयो / Resolved',
    'अस्वीकृत / Rejected',
  ];

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'स्थिति अपडेट गर्नुहोस् / Update Status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Status dropdown
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'नयाँ स्थिति / New Status',
              prefixIcon: Icon(Icons.update),
            ),
            items: _statuses.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedStatus = value),
          ),
          const SizedBox(height: 16),

          // Response text field
          TextFormField(
            controller: _responseController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'प्रतिक्रिया / Response',
              hintText: 'अपडेटको बारेमा विवरण लेख्नुहोस्...',
              prefixIcon: Icon(Icons.message),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('रद्द गर्नुहोस् / Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement update functionality
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('अपडेट सफल भयो / Update successful'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('अपडेट / Update'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
