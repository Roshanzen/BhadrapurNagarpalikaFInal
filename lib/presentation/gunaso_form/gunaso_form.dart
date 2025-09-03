import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../gunaso_form/widgets/my_complaint_page.dart'; // <-- Import MyComplaintPage
import '../../core/app_export.dart';

// Simple local storage for submitted gunasos (for demo purposes)
class GunasoStorage {
  static const String _key = 'submitted_gunasos';

  static Future<void> saveGunaso(Map<String, dynamic> gunaso) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getGunasos();
    existing.add(gunaso);
    await prefs.setString(_key, json.encode(existing));
  }

  static Future<List<Map<String, dynamic>>> getGunasos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> clearGunasos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

class GunasoForm extends StatefulWidget {
  const GunasoForm({super.key});

  @override
  _GunasoFormState createState() => _GunasoFormState();
}

class _GunasoFormState extends State<GunasoForm> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdController = TextEditingController();
  final _gunashoPlaceController = TextEditingController();
  final _popularPlaceController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _headingController = TextEditingController();
  final _messageController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _sakhaIdController = TextEditingController();
  final _orgIdController = TextEditingController();

  bool _isLoading = false;
  String? _responseMessage;
  final List<File> _selectedFiles = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load user data from SharedPreferences
    final memberId = prefs.getString('memberId') ?? '';
    final memberName = prefs.getString('memberName') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final orgId = prefs.getString('orgId') ?? '';

    setState(() {
      _memberIdController.text = memberId;
      _fullNameController.text = memberName;
      _phoneNumberController.text = phone;
      _orgIdController.text = orgId;
      _gunashoPlaceController.text = 'भद्रपुर नगरपालिका';
      _popularPlaceController.text = 'भद्रपुर';
      _headingController.text = '';
      _messageController.text = '';
      _sakhaIdController.text = '';
      _isInitialized = true;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFiles.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(
          result.paths.map((path) => File(path!)).toList(),
        );
      });
    }
  }

  Future<void> _submitGunaso(String url) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    // Check if we're in demo mode (no memberId)
    final isDemoMode = _memberIdController.text.isEmpty || _memberIdController.text == 'null';

    if (isDemoMode) {
      // Demo mode - simulate successful submission
      await Future.delayed(const Duration(seconds: 2));

      // Save to local storage for officer view
      final submittedGunaso = {
        'id': 'C${DateTime.now().millisecondsSinceEpoch}',
        'heading': _headingController.text,
        'message': _messageController.text,
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'gunashoPlace': _gunashoPlaceController.text,
        'popularPlace': _popularPlaceController.text,
        'memberId': _memberIdController.text,
        'orgId': _orgIdController.text,
        'sakhaId': _sakhaIdController.text,
        'status': 'बाँकी',
        'priority': 'मध्यम',
        'createdDate': DateTime.now().toIso8601String(),
        'ward': 1, // Default ward
        'category': 'सामान्य' // Default category
      };

      // await GunasoStorage.saveGunaso(submittedGunaso);

      setState(() {
        _isLoading = false;
        _responseMessage = 'Demo Mode: Gunaso submitted successfully!';

        // Navigate to MyComplaintPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyComplaintPage(
              memberId: _memberIdController.text,
            ),
          ),
        );

        // Clear fields
        _formKey.currentState!.reset();
        _memberIdController.clear();
        _gunashoPlaceController.clear();
        _popularPlaceController.clear();
        _fullNameController.clear();
        _headingController.clear();
        _messageController.clear();
        _phoneNumberController.clear();
        _sakhaIdController.clear();
        _orgIdController.clear();
        _selectedFiles.clear();
      });
      return;
    }

    // Real API submission
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Add form fields
    request.fields['memberIdOrGUserFbId'] = _memberIdController.text;
    request.fields['gunashoPlace'] = _gunashoPlaceController.text;
    request.fields['popularPlace'] = _popularPlaceController.text;
    request.fields['fullName'] = _fullNameController.text;
    request.fields['heading'] = _headingController.text;
    request.fields['message'] = _messageController.text;
    request.fields['phoneNumber'] = _phoneNumberController.text;
    request.fields['sakhaId'] = _sakhaIdController.text;
    request.fields['orgId'] = _orgIdController.text;

    // Add files
    for (var file in _selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath('files', file.path),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          _responseMessage = 'Gunaso submitted successfully!';

          // Save to local storage for officer view
          final submittedGunaso = {
            'id': 'C${DateTime.now().millisecondsSinceEpoch}',
            'heading': _headingController.text,
            'message': _messageController.text,
            'fullName': _fullNameController.text,
            'phoneNumber': _phoneNumberController.text,
            'gunashoPlace': _gunashoPlaceController.text,
            'popularPlace': _popularPlaceController.text,
            'memberId': _memberIdController.text,
            'orgId': _orgIdController.text,
            'sakhaId': _sakhaIdController.text,
            'status': 'बाँकी',
            'priority': 'मध्यम',
            'createdDate': DateTime.now().toIso8601String(),
            'ward': 1, // Default ward
            'category': 'सामान्य' // Default category
          };

          // Temporarily disabled due to async issue
          // await GunasoStorage.saveGunaso(submittedGunaso);

          // Navigate to MyComplaintPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyComplaintPage(
                memberId: _memberIdController.text,
              ),
            ),
          );

          // Clear fields
          _formKey.currentState!.reset();
          _memberIdController.clear();
          _gunashoPlaceController.clear();
          _popularPlaceController.clear();
          _fullNameController.clear();
          _headingController.clear();
          _messageController.clear();
          _phoneNumberController.clear();
          _sakhaIdController.clear();
          _orgIdController.clear();
          _selectedFiles.clear();
        } else {
          _responseMessage = 'Failed to submit Gunaso: ${response.statusCode}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _gunashoPlaceController.dispose();
    _popularPlaceController.dispose();
    _fullNameController.dispose();
    _headingController.dispose();
    _messageController.dispose();
    _phoneNumberController.dispose();
    _sakhaIdController.dispose();
    _orgIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        title: Text(
          'गुनासो दर्ता गर्नुहोस्',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Container(
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
                            iconName: 'edit',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 8.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'गुनासो दर्ता',
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'तपाईंको गुनासो दर्ता गर्नका लागि आवश्यक जानकारीहरू भर्नुहोस्।',
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Personal Information Section
                  _buildSectionHeader('व्यक्तिगत जानकारी', 'person'),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _fullNameController,
                    label: 'पुरा नाम',
                    hint: 'तपाईंको पुरा नाम लेख्नुहोस्',
                    icon: 'person',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया पुरा नाम लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _phoneNumberController,
                    label: 'फोन नम्बर',
                    hint: 'तपाईंको फोन नम्बर लेख्नुहोस्',
                    icon: 'phone',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया फोन नम्बर लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Location Information Section
                  _buildSectionHeader('स्थान जानकारी', 'location_city'),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _gunashoPlaceController,
                    label: 'गुनासो स्थान',
                    hint: 'गुनासो भएको स्थान लेख्नुहोस्',
                    icon: 'location_city',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया गुनासो स्थान लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _popularPlaceController,
                    label: 'प्रसिद्ध स्थान',
                    hint: 'नजिकको प्रसिद्ध स्थान लेख्नुहोस्',
                    icon: 'place',
                  ),
                  SizedBox(height: 3.h),

                  // Complaint Details Section
                  _buildSectionHeader('गुनासो विवरण', 'description'),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _headingController,
                    label: 'गुनासो शीर्षक',
                    hint: 'गुनासोको संक्षिप्त शीर्षक लेख्नुहोस्',
                    icon: 'title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया गुनासो शीर्षक लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _messageController,
                    label: 'गुनासो विवरण',
                    hint: 'गुनासोको विस्तृत विवरण लेख्नुहोस्',
                    icon: 'message',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया गुनासो विवरण लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Administrative Information Section
                  _buildSectionHeader('प्रशासनिक जानकारी', 'admin_panel_settings'),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _memberIdController,
                    label: 'सदस्य ID',
                    hint: 'तपाईंको सदस्य ID लेख्नुहोस्',
                    icon: 'badge',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया सदस्य ID लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _orgIdController,
                    label: 'संगठन ID',
                    hint: 'तपाईंको संगठन ID लेख्नुहोस्',
                    icon: 'business',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया संगठन ID लेख्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildModernTextField(
                    controller: _sakhaIdController,
                    label: 'शाखा ID',
                    hint: 'तपाईंको शाखा ID लेख्नुहोस्',
                    icon: 'account_tree',
                  ),
                  SizedBox(height: 3.h),

                  // File Upload Section
                  _buildSectionHeader('फाइलहरू संलग्न गर्नुहोस्', 'attach_file'),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildUploadButton(
                              icon: 'photo_library',
                              label: 'ग्यालरी',
                              onPressed: () => _pickImage(ImageSource.gallery),
                            ),
                            _buildUploadButton(
                              icon: 'camera_alt',
                              label: 'क्यामेरा',
                              onPressed: () => _pickImage(ImageSource.camera),
                            ),
                            _buildUploadButton(
                              icon: 'attach_file',
                              label: 'फाइल',
                              onPressed: _pickFile,
                            ),
                          ],
                        ),
                        if (_selectedFiles.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 2.w,
                            children: _selectedFiles.map((file) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'insert_drive_file',
                                      color: AppTheme.lightTheme.colorScheme.primary,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file.path.split('/').last,
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedFiles.remove(file);
                                        });
                                      },
                                      child: CustomIconWidget(
                                        iconName: 'close',
                                        color: AppTheme.lightTheme.colorScheme.error,
                                        size: 3.w,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: 14.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _submitGunaso(
                              'https://uat.nirc.com.np:8443/GWP/message/addGunashoFromMobile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'गुनासो दर्ता गर्नुहोस्',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_responseMessage != null)
            Positioned(
              bottom: 4.h,
              left: 4.w,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _responseMessage!.contains('successfully')
                      ? Colors.green
                      : AppTheme.lightTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _responseMessage!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconName) {
    return Row(
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
        SizedBox(width: 2.w),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(2.w),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildUploadButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
