import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../core/language_manager.dart';
import './widgets/officer_profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  String _selectedLanguage = 'ne'; // Default to Nepali

  // Mock officer data - in real app, this would be fetched from API
  Map<String, dynamic> officerData = {
    "id": 1,
    "name": "राम बहादुर श्रेष्ठ",
    "designation": "सहायक प्रशासकीय अधिकृत",
    "profileImage":
    "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "department": "सामान्य प्रशासन",
    "phone": "+977-9841234567",
    "email": "ram.shrestha@bhadrapur.gov.np",
    "address": "भद्रपुर नगरपालिका, झापा",
    "joinDate": "२०७५/०१/१५",
    "employeeId": "EMP001"
  };

  final Map<String, String> _languages = {
    'ne': 'नेपाली',
    'en': 'English',
    'hi': 'हिन्दी',
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = officerData["name"];
    _phoneController.text = officerData["phone"];
    _emailController.text = officerData["email"];
    _addressController.text = officerData["address"];
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedLanguage = prefs.getString('selected_language');
      setState(() {
        _selectedLanguage = savedLanguage ?? 'ne'; // Default to Nepali
      });
    } catch (e) {
      // If there's an error loading preferences, use default
      setState(() {
        _selectedLanguage = 'ne';
      });
    }
  }

  Future<void> _changeLanguage(String languageCode) async {
    try {
      // Save to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', languageCode);

      setState(() {
        _selectedLanguage = languageCode;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${LanguageManager.getString('language_changed', languageCode)}: ${LanguageManager.getLanguageNames()[languageCode]}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );

      // Note: In a production app, you would typically restart the app
      // or use a localization package like flutter_localizations
      // to apply language changes throughout the entire app
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LanguageManager.getString('language_change_failed', _selectedLanguage)),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset to original values if canceling edit
        _nameController.text = officerData["name"];
        _phoneController.text = officerData["phone"];
        _emailController.text = officerData["email"];
        _addressController.text = officerData["address"];
      }
    });
  }

  void _saveProfile() {
    setState(() {
      officerData["name"] = _nameController.text;
      officerData["phone"] = _phoneController.text;
      officerData["email"] = _emailController.text;
      officerData["address"] = _addressController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('प्रोफाइल अपडेट गरियो'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LanguageManager.getString('select_language', _selectedLanguage)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageManager.getLanguageNames().entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    Navigator.of(context).pop();
                    _changeLanguage(value);
                  }
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LanguageManager.getString('cancel', _selectedLanguage)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('लगआउट'),
          content: const Text('के तपाईं लगआउट गर्न चाहनुहुन्छ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('रद्द गर्नुहोस्'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, '/role-selection-screen');
              },
              child: const Text('लगआउट'),
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
        title: Text(LanguageManager.getString('profile', _selectedLanguage)),
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
              iconName: _isEditing ? 'save' : 'edit',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
          ),
          if (_isEditing)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              onPressed: _toggleEdit,
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Officer Header with Logout
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        officerData["profileImage"] as String,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          officerData["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          officerData["designation"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: _showLogoutDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.logout,
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Personal Information Section
            Text(
              LanguageManager.getString('personal_info', _selectedLanguage),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileField(
                    label: 'पुरा नाम',
                    controller: _nameController,
                    icon: 'person',
                    enabled: _isEditing,
                  ),
                  SizedBox(height: 2.h),
                  _buildProfileField(
                    label: 'फोन नम्बर',
                    controller: _phoneController,
                    icon: 'phone',
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 2.h),
                  _buildProfileField(
                    label: 'इमेल',
                    controller: _emailController,
                    icon: 'email',
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 2.h),
                  _buildProfileField(
                    label: 'ठेगाना',
                    controller: _addressController,
                    icon: 'location_on',
                    enabled: _isEditing,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Work Information Section
            Text(
              LanguageManager.getString('work_info', _selectedLanguage),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow('पद', officerData["designation"] as String),
                  SizedBox(height: 2.h),
                  _buildInfoRow('विभाग', officerData["department"] as String),
                  SizedBox(height: 2.h),
                  _buildInfoRow('कर्मचारी ID', officerData["employeeId"] as String),
                  SizedBox(height: 2.h),
                  _buildInfoRow('सामेल मिति', officerData["joinDate"] as String),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Account Actions
            Text(
              LanguageManager.getString('account_settings', _selectedLanguage),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: const Text('पासवर्ड परिवर्तन गर्नुहोस्'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to change password
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('पासवर्ड परिवर्तन सुविधा निर्माणाधीन')),
                      );
                    },
                  ),
                  Divider(height: 1, color: AppTheme.lightTheme.colorScheme.outline),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'notifications',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: const Text('सूचना सेटिङहरू'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to notification settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('सूचना सेटिङहरू निर्माणाधीन')),
                      );
                    },
                  ),
                  Divider(height: 1, color: AppTheme.lightTheme.colorScheme.outline),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'language',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(LanguageManager.getString('change_language', _selectedLanguage)),
                    subtitle: Text(LanguageManager.getLanguageNames()[_selectedLanguage] ?? 'नेपाली'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onTap: () => _showLanguageSelectionDialog(),
                  ),
                  Divider(height: 1, color: AppTheme.lightTheme.colorScheme.outline),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    title: const Text('मद्दत र सहयोग'),
                    trailing: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    onTap: () {
                      // Navigate to help
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('मद्दत र सहयोग निर्माणाधीन')),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h), // Space for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required String icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              border: enabled ? const OutlineInputBorder() : InputBorder.none,
              filled: !enabled,
              fillColor: enabled
                  ? Colors.transparent
                  : AppTheme.lightTheme.colorScheme.surfaceVariant.withValues(alpha: 0.1),
            ),
            style: enabled
                ? null
                : AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}