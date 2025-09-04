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

// Simple local storage for submitted gunasos (for officer dashboard)
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Required data from SharedPreferences
    final memberId = prefs.getString('memberId');
    final facebookId = prefs.getString('facebookId');
    final memberName = prefs.getString('memberName');
    final userName = prefs.getString('userName');
    final orgId = prefs.getString('orgId');
    final orgName = prefs.getString('orgName');
    final selectedWardName = prefs.getString('selectedWardName');
    
    // Debug logging
    print('=== GUNASO FORM DEBUG ===');
    print('memberId: $memberId');
    print('facebookId: $facebookId');
    print('memberName: $memberName');
    print('userName: $userName');
    print('orgId: $orgId');
    print('orgName: $orgName');
    print('selectedWardName: $selectedWardName');
    
    // Use userName as fallback for memberName
    final finalMemberName = memberName ?? userName;
    
    // Check if required data exists - if not, use demo data for testing
    if (memberId == null || finalMemberName == null || orgId == null) {
      print('Missing data - memberId: $memberId, memberName: $finalMemberName, orgId: $orgId');
      print('Using demo data for testing purposes');

      // Use demo data
      setState(() {
        _memberIdController.text = facebookId ?? 'demo_user_123';
        _fullNameController.text = finalMemberName ?? 'Demo User';
        _phoneNumberController.text = '+977-XXXXXXXXXX';
        _orgIdController.text = orgId ?? '642'; // Default org ID
        _gunashoPlaceController.text = selectedWardName ?? orgName ?? 'Demo Location';
        _popularPlaceController.text = (selectedWardName ?? orgName)?.split(' ')[0] ?? 'Demo Place';
        _sakhaIdController.text = '1';
        _isInitialized = true;

        print('Demo form initialized successfully');
      });
      return;
    }

    setState(() {
      _memberIdController.text = facebookId ?? memberId; // Use facebookId if available, else memberId
      _fullNameController.text = finalMemberName;
      _phoneNumberController.text = '+977-XXXXXXXXXX'; // User can edit
      _orgIdController.text = orgId;
      _gunashoPlaceController.text = selectedWardName ?? orgName ?? 'नगरपालिका';
      _popularPlaceController.text = (selectedWardName ?? orgName)?.split(' ')[0] ?? 'स्थान';
      _sakhaIdController.text = '1'; // Default department
      _isInitialized = true;
      
      print('Form initialized successfully with:');
      print('Member ID: ${_memberIdController.text}');
      print('Full Name: ${_fullNameController.text}');
      print('Org ID: ${_orgIdController.text}');
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

  Future<void> _submitGunaso() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    const String apiUrl = 'https://uat.nirc.com.np:8443/GWP/message/addGunashoFromMobile';
    
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields matching backend API
      request.fields['memberIdOrGUserFbId'] = _memberIdController.text;
      request.fields['gunashoPlace'] = _gunashoPlaceController.text;
      request.fields['popularPlace'] = _popularPlaceController.text;
      request.fields['fullName'] = _fullNameController.text;
      request.fields['heading'] = _headingController.text;
      request.fields['message'] = _messageController.text;
      request.fields['phoneNumber'] = _phoneNumberController.text;
      request.fields['orgId'] = _orgIdController.text;
      request.fields['sakhaId'] = _sakhaIdController.text;

      // Add files if any
      for (var file in _selectedFiles) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        final statusCode = jsonResponse['statusCode'] is String
            ? int.tryParse(jsonResponse['statusCode']) ?? 300
            : jsonResponse['statusCode'] ?? 300;

        setState(() {
          _isLoading = false;
          if (statusCode == 200 && jsonResponse['success'] == true) {
            _responseMessage = jsonResponse['message'] ?? 'Gunaso submitted successfully!';
          } else {
            _responseMessage = jsonResponse['message'] ?? 'Gunaso saved locally - will sync when online';
          }
        });

        // Always save locally for officer dashboard, regardless of API success
        final submittedGunaso = {
          'id': jsonResponse['data']?['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'heading': _headingController.text,
          'message': _messageController.text,
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'gunashoPlace': _gunashoPlaceController.text,
          'popularPlace': _popularPlaceController.text,
          'orgId': _orgIdController.text,
          'sakhaId': _sakhaIdController.text,
          'createdDate': DateTime.now().toString(),
          'status': 'बाँकी',
          'priority': 'मध्यम',
          'ward': 1,
          'category': 'सामान्य'
        };

        await GunasoStorage.saveGunaso(submittedGunaso);
      } catch (e) {
        print('API call failed: $e');
        setState(() {
          _isLoading = false;
          _responseMessage = 'Gunaso saved locally - network error, will sync when online';
        });

        // Save locally even if API call fails
        final submittedGunaso = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'heading': _headingController.text,
          'message': _messageController.text,
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'gunashoPlace': _gunashoPlaceController.text,
          'popularPlace': _popularPlaceController.text,
          'orgId': _orgIdController.text,
          'sakhaId': _sakhaIdController.text,
          'createdDate': DateTime.now().toString(),
          'status': 'बाँकी',
          'priority': 'मध्यम',
          'ward': 1,
          'category': 'सामान्य'
        };

        await GunasoStorage.saveGunaso(submittedGunaso);
      }

      // Always navigate after saving locally
      final prefs = await SharedPreferences.getInstance();
      final facebookId = prefs.getString('facebookId') ?? _memberIdController.text;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyComplaintPage(
            memberId: facebookId,
          ),
        ),
      );
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
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactTextField(
                          controller: _fullNameController,
                          label: 'पुरा नाम',
                          icon: 'person',
                          validator: (value) => value?.isEmpty == true ? 'आवश्यक' : null,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildCompactTextField(
                          controller: _phoneNumberController,
                          label: 'फोन नम्बर',
                          icon: 'phone',
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.isEmpty == true ? 'आवश्यक' : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Location Information Section
                  _buildSectionHeader('स्थान जानकारी', 'location_city'),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCompactTextField(
                          controller: _gunashoPlaceController,
                          label: 'गुनासो स्थान',
                          icon: 'location_city',
                          validator: (value) => value?.isEmpty == true ? 'आवश्यक' : null,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildCompactTextField(
                          controller: _popularPlaceController,
                          label: 'प्रसिद्ध स्थान',
                          icon: 'place',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Complaint Details Section
                  _buildSectionHeader('गुनासो विवरण', 'description'),
                  SizedBox(height: 1.5.h),
                  _buildCompactTextField(
                    controller: _headingController,
                    label: 'गुनासो शीर्षक',
                    icon: 'title',
                    validator: (value) => value?.isEmpty == true ? 'आवश्यक' : null,
                  ),
                  SizedBox(height: 1.5.h),
                  _buildCompactTextField(
                    controller: _messageController,
                    label: 'गुनासो विवरण',
                    icon: 'message',
                    maxLines: 3,
                    validator: (value) => value?.isEmpty == true ? 'आवश्यक' : null,
                  ),
                  SizedBox(height: 2.h),

                  // File Upload Section
                  _buildSectionHeader('फाइलहरू संलग्न गर्नुहोस्', 'attach_file'),
                  SizedBox(height: 1.5.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
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
                            _buildCompactUploadButton(
                              icon: 'photo_library',
                              label: 'ग्यालरी',
                              onPressed: () => _pickImage(ImageSource.gallery),
                            ),
                            _buildCompactUploadButton(
                              icon: 'camera_alt',
                              label: 'क्यामेरा',
                              onPressed: () => _pickImage(ImageSource.camera),
                            ),
                            _buildCompactUploadButton(
                              icon: 'attach_file',
                              label: 'फाइल',
                              onPressed: _pickFile,
                            ),
                          ],
                        ),
                        if (_selectedFiles.isNotEmpty) ...[
                          SizedBox(height: 1.5.h),
                          Wrap(
                            spacing: 1.5.w,
                            runSpacing: 1.h,
                            children: _selectedFiles.map((file) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'insert_drive_file',
                                      color: AppTheme.lightTheme.colorScheme.primary,
                                      size: 3.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      file.path.split('/').last.length > 15 
                                          ? '${file.path.split('/').last.substring(0, 15)}...'
                                          : file.path.split('/').last,
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    GestureDetector(
                                      onTap: () => setState(() => _selectedFiles.remove(file)),
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
                  SizedBox(height: 3.h),

                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: 12.w,
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
                      onPressed: _isLoading ? null : _submitGunaso,
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
                  SizedBox(height: 3.h),
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

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required String icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontSize: 12.sp,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 11.sp,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(1.5.w),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCompactUploadButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
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
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
