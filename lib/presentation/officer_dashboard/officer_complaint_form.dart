import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';

class OfficerComplaintForm extends StatefulWidget {
  const OfficerComplaintForm({super.key});

  @override
  State<OfficerComplaintForm> createState() => _OfficerComplaintFormState();
}

class _OfficerComplaintFormState extends State<OfficerComplaintForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  final String _selectedLanguage = 'ne'; // Default to Nepali
  String _selectedPriority = 'मध्यम';
  String _selectedCategory = 'सामान्य प्रशासन';
  String _selectedOfficeLevel = 'जिल्ला कार्यालय';
  bool _isUrgent = false;
  bool _isLoading = false;
  final List<File> _selectedFiles = [];

  final List<String> _priorities = ['न्यून', 'मध्यम', 'उच्च', 'अत्यधिक'];
  final List<String> _categories = [
    'सामान्य प्रशासन',
    'पूर्वाधार विकास',
    'सफाई तथा सरसफाई',
    'स्वास्थ्य सेवा',
    'शिक्षा',
    'सुरक्षा',
    'वित्तीय',
    'अन्य'
  ];
  final List<String> _officeLevels = [
    'जिल्ला कार्यालय',
    'प्रदेश कार्यालय',
    'केन्द्रीय कार्यालय',
    'मन्त्रालय'
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedFiles.add(File(pickedFile.path));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('फोटो सफलतापूर्वक थपियो'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('फोटो लोड गर्न असफल: ${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.paths.isNotEmpty) {
        setState(() {
          _selectedFiles.addAll(
            result.paths.where((path) => path != null).map((path) => File(path!)).toList(),
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.paths.length} फाइलहरू सफलतापूर्वक थपियो'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('फाइल लोड गर्न असफल: ${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LanguageManager.getString('fill_required_fields', _selectedLanguage)),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Optional: Check if user wants to attach files
    if (_selectedFiles.isEmpty) {
      final attachFiles = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('कागजात संलग्न गर्नुहुन्छ?'),
          content: const Text('तपाईंले कुनै कागजात संलग्न गर्नुभएको छैन। के तपाईं जारी राख्न चाहनुहुन्छ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('फाइल थप्नुहोस्'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('जारी राख्नुहोस्'),
            ),
          ],
        ),
      );

      if (attachFiles == false) return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LanguageManager.getString('complaint_submitted', _selectedLanguage)),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );

        // Navigate back to dashboard
        Navigator.of(context).pushReplacementNamed('/officer-dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LanguageManager.getString('submission_failed', _selectedLanguage)),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(LanguageManager.getString('officer_complaint_form', _selectedLanguage)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/officer-dashboard');
          },
        ),
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
                    LanguageManager.getString('submitting', _selectedLanguage),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'assignment',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'यो फारम उच्च अधिकारीहरूलाई गुनासो पेश गर्नका लागि हो',
                              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('complaint_title', _selectedLanguage),
                        hintText: LanguageManager.getString('complaint_title', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'title',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'गुनासोको शीर्षक अनिवार्य छ';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('complaint_description', _selectedLanguage),
                        hintText: LanguageManager.getString('complaint_description', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'गुनासोको विवरण अनिवार्य छ';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('location', _selectedLanguage),
                        hintText: LanguageManager.getString('location', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Contact
                    TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('contact_number', _selectedLanguage),
                        hintText: LanguageManager.getString('contact_number', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'phone',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 3.h),

                    // Priority Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPriority,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('priority', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'priority_high',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      items: _priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value!;
                        });
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('category', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'category',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Office Level Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedOfficeLevel,
                      decoration: InputDecoration(
                        labelText: LanguageManager.getString('submit_to_office', _selectedLanguage),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: CustomIconWidget(
                          iconName: 'business',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      items: _officeLevels.map((level) {
                        return DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOfficeLevel = value!;
                        });
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Urgent Checkbox
                    CheckboxListTile(
                      title: const Text('अत्यधिक महत्वपूर्ण (तत्काल कारबाही आवश्यक)'),
                      value: _isUrgent,
                      onChanged: (value) {
                        setState(() {
                          _isUrgent = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    SizedBox(height: 3.h),

                    // File Attachments
                    Text(
                      'कागजात संलग्न गर्नुहोस्',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Attachment Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: CustomIconWidget(
                            iconName: 'photo_library',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: const Text('ग्यालरी'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: CustomIconWidget(
                            iconName: 'camera_alt',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: const Text('क्यामरा'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: CustomIconWidget(
                            iconName: 'attach_file',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: const Text('फाइल'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Selected Files
                    if (_selectedFiles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'संलग्न फाइलहरू (${_selectedFiles.length})',
                              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: _selectedFiles.map((file) {
                                return Chip(
                                  label: Text(
                                    file.path.split('/').last,
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedFiles.remove(file);
                                    });
                                  },
                                  deleteIcon: Icon(Icons.close, size: 16),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 4.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitComplaint,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 3.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          LanguageManager.getString('submit', _selectedLanguage),
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
    );
  }
}