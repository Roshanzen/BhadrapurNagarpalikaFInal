import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/attachment_section_widget.dart';
import './widgets/location_section_widget.dart';
import './widgets/priority_selector_widget.dart';

class ComplaintSubmissionForm extends StatefulWidget {
  const ComplaintSubmissionForm({super.key});

  @override
  State<ComplaintSubmissionForm> createState() =>
      _ComplaintSubmissionFormState();
}

class _ComplaintSubmissionFormState extends State<ComplaintSubmissionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedWard;
  String? _selectedCategory;
  Priority? _selectedPriority;
  String? _selectedLocation;
  String? _manualAddress;
  List<XFile> _attachments = [];
  bool _isSubmitting = false;
  bool _isOfficerMode = false; // This should come from user session in real app

  // Mock data - in real app, this would come from API
  final List<String> _wards = [
    'वडा नम्बर १ / Ward 1',
    'वडा नम्बर २ / Ward 2',
    'वडा नम्बर ३ / Ward 3',
    'वडा नम्बर ४ / Ward 4',
    'वडा नम्बर ५ / Ward 5',
    'वडा नम्बर ६ / Ward 6',
    'वडा नम्बर ७ / Ward 7',
    'वडा नम्बर ८ / Ward 8',
    'वडा नम्बर ९ / Ward 9',
  ];

  final List<Map<String, String>> _categories = [
    {'ne': 'सडक र यातायात', 'en': 'Roads & Transportation'},
    {'ne': 'पानी आपूर्ति', 'en': 'Water Supply'},
    {'ne': 'फोहोर व्यवस्थापन', 'en': 'Waste Management'},
    {'ne': 'बिजुली र बत्ती', 'en': 'Electricity & Street Lights'},
    {'ne': 'ढल निकास', 'en': 'Drainage & Sewerage'},
    {'ne': 'सार्वजनिक स्वास्थ्य', 'en': 'Public Health'},
    {'ne': 'पार्क र मनोरञ्जन', 'en': 'Parks & Recreation'},
    {'ne': 'शिक्षा', 'en': 'Education'},
    {'ne': 'अन्य', 'en': 'Others'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get officer mode from route arguments
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isOfficerMode = args?['isOfficerMode'] ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'कम्तिमा एउटा फोटो संलग्न गर्नुहोस् / Please attach at least one photo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      // Generate mock complaint ID
      final complaintId =
          'CMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.tertiary,
              size: 48,
            ),
            title: const Text('सफलतापूर्वक पेश गरियो\nSuccessfully Submitted'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'तपाईंको गुनासो सफलतापूर्वक पेश गरिएको छ।\nYour complaint has been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'गुनासो आईडी / Complaint ID',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        complaintId,
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.complaintDetailView,
                        (route) =>
                    route.settings.name == AppRoutes.citizenDashboard ||
                        route.settings.name == AppRoutes.officerDashboard,
                    arguments: {'complaintId': complaintId},
                  );
                },
                child: const Text('विस्तार हेर्नुहोस् / View Details'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('धन्यवाद / Thank You'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
            Text('गुनासो पेश गर्न समस्या भयो / Error submitting complaint'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('गुनासो दर्ता / Submit Complaint'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isSubmitting)
            TextButton(
              onPressed: _submitComplaint,
              child: Text(
                'पेश गर्नुहोस् / Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'शीर्षक / Title *',
                hintText: 'गुनासोको छोटो शीर्षक लेख्नुहोस्...',
                prefixIcon: const Icon(Icons.title),
                counterText: '${_titleController.text.length}/100',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'शीर्षक आवश्यक छ / Title is required';
                }
                if (value!.length < 5) {
                  return 'शीर्षक कम्तिमा ५ अक्षर हुनुपर्छ / Title must be at least 5 characters';
                }
                return null;
              },
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'विस्तृत विवरण / Detailed Description *',
                hintText:
                'गुनासोको पूर्ण विवरण यहाँ लेख्नुहोस्...\nWrite complete details of your complaint here...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'विवरण आवश्यक छ / Description is required';
                }
                if (value!.length < 20) {
                  return 'विवरण कम्तिमा २० अक्षर हुनुपर्छ / Description must be at least 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Ward Selection
            DropdownButtonFormField<String>(
              value: _selectedWard,
              decoration: const InputDecoration(
                labelText: 'वडा नम्बर / Ward Number *',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _wards.map((ward) {
                return DropdownMenuItem(
                  value: ward,
                  child: Text(ward),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedWard = value),
              validator: (value) {
                if (value == null) {
                  return 'वडा नम्बर छान्नुहोस् / Please select ward number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category Selection
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'गुनासो प्रकार / Complaint Category *',
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: '${category['ne']} / ${category['en']}',
                  child: Text('${category['ne']} / ${category['en']}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (value) {
                if (value == null) {
                  return 'गुनासो प्रकार छान्नुहोस् / Please select complaint category';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Priority Selection (Officers only)
            PrioritySelectorWidget(
              selectedPriority: _selectedPriority,
              onPriorityChanged: (priority) =>
                  setState(() => _selectedPriority = priority),
              isOfficerMode: _isOfficerMode,
            ),
            if (_isOfficerMode) const SizedBox(height: 24),

            // Attachment Section
            AttachmentSectionWidget(
              attachments: _attachments,
              onAttachmentsChanged: (attachments) =>
                  setState(() => _attachments = attachments),
            ),
            const SizedBox(height: 24),

            // Location Section
            LocationSectionWidget(
              selectedLocation: _selectedLocation,
              manualAddress: _manualAddress,
              onLocationChanged: (location) =>
                  setState(() => _selectedLocation = location),
              onManualAddressChanged: (address) =>
                  setState(() => _manualAddress = address),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                child: _isSubmitting
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('पेश गर्दै... / Submitting...'),
                  ],
                )
                    : const Text('गुनासो पेश गर्नुहोस् / Submit Complaint'),
              ),
            ),
            const SizedBox(height: 16),

            // Draft save info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'तपाईंको जानकारी स्वतः सेभ हुन्छ / Your information is automatically saved',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
}
