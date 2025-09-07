import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/language_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  late LanguageService _languageService;
  String _selectedLanguage = 'नेपाली';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLanguageService();
  }

  Future<void> _initializeLanguageService() async {
    _languageService = LanguageService();
    await _languageService.initialize();
    setState(() {
      _selectedLanguage = _languageService.currentLanguageCode == 'ne' ? 'नेपाली' : 'English';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
          centerTitle: true,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageService.currentLanguageCode == 'ne' ? 'सेटिङ्गहरू' : 'Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'सूचना सेटिङ्गहरू' : 'Notification Settings'),
            _buildSwitchTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'सूचना सक्षम गर्नुहोस्' : 'Enable Notifications',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'गुनासो अपडेटहरू र सूचनाहरू प्राप्त गर्नुहोस्' : 'Receive complaint updates and notifications',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'सुरक्षा सेटिङ्गहरू' : 'Security Settings'),
            _buildSwitchTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'बायोमेट्रिक प्रमाणीकरण' : 'Biometric Authentication',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'फिंगरप्रिन्ट वा फेस आईडी प्रयोग गर्नुहोस्' : 'Use fingerprint or face ID',
              value: _biometricEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricEnabled = value;
                });
              },
            ),
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'देखावट सेटिङ्गहरू' : 'Appearance Settings'),
            _buildSwitchTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'डार्क मोड' : 'Dark Mode',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'अँध्यारो थिम प्रयोग गर्नुहोस्' : 'Use dark theme',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'भाषा सेटिङ्गहरू' : 'Language Settings'),
            _buildLanguageSelector(),
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'खाता सेटिङ्गहरू' : 'Account Settings'),
            _buildActionTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'पासवर्ड परिवर्तन गर्नुहोस्' : 'Change Password',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'तपाईंको खाता पासवर्ड अपडेट गर्नुहोस्' : 'Update your account password',
              onTap: () => _showChangePasswordDialog(context),
            ),
            _buildActionTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'डेटा निर्यात गर्नुहोस्' : 'Export Data',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'तपाईंको सबै डेटा डाउनलोड गर्नुहोस्' : 'Download all your data',
              onTap: () => _exportData(context),
            ),
            _buildSectionHeader(_languageService.currentLanguageCode == 'ne' ? 'अन्य' : 'Other'),
            _buildActionTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'हामीलाई मूल्याङ्कन गर्नुहोस्' : 'Rate Us',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'एप स्टोरमा हामीलाई रेट गर्नुहोस्' : 'Rate us on the app store',
              onTap: () => _rateApp(context),
            ),
            _buildActionTile(
              title: _languageService.currentLanguageCode == 'ne' ? 'सम्पर्क गर्नुहोस्' : 'Contact Us',
              subtitle: _languageService.currentLanguageCode == 'ne' ? 'हाम्रो सहायता टिमसँग सम्पर्क गर्नुहोस्' : 'Contact our support team',
              onTap: () => _contactSupport(context),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      title: Text(
        _languageService.currentLanguageCode == 'ne' ? 'भाषा चयन गर्नुहोस्' : 'Select Language',
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        _languageService.currentLanguageCode == 'ne' ? 'एपको भाषा परिवर्तन गर्नुहोस्' : 'Change app language',
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        items: ['नेपाली', 'English'].map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null && newValue != _selectedLanguage) {
            _showLanguageChangeDialog(newValue);
          }
        },
      ),
    );
  }

  void _showLanguageChangeDialog(String newLanguage) {
    final languageCode = newLanguage == 'नेपाली' ? 'ne' : 'en';
    final languageName = newLanguage == 'नेपाली' ? 'नेपाली' : 'English';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text(
          _languageService.currentLanguageCode == 'ne' ? 'भाषा परिवर्तन' : 'Language Change',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          _languageService.currentLanguageCode == 'ne'
              ? 'के तपाईं भाषा $languageName मा परिवर्तन गर्न चाहनुहुन्छ?'
              : 'Do you want to change language to $languageName?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_languageService.currentLanguageCode == 'ne' ? 'रद्द गर्नुहोस्' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changeLanguage(languageCode, newLanguage);
            },
            child: Text(_languageService.currentLanguageCode == 'ne' ? 'परिवर्तन गर्नुहोस्' : 'Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(String languageCode, String languageName) async {
    try {
      await _languageService.setLanguageCode(languageCode);

      setState(() {
        _selectedLanguage = languageName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageCode == 'ne'
              ? 'भाषा $languageName मा परिवर्तन गरियो'
              : 'Language changed to $languageName'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to refresh the UI with new language
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageCode == 'ne'
              ? 'भाषा परिवर्तन गर्न असफल भयो'
              : 'Failed to change language'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _languageService.currentLanguageCode == 'ne' ? 'पासवर्ड परिवर्तन गर्नुहोस्' : 'Change Password',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: _languageService.currentLanguageCode == 'ne' ? 'हालको पासवर्ड' : 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: _languageService.currentLanguageCode == 'ne' ? 'नयाँ पासवर्ड' : 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: _languageService.currentLanguageCode == 'ne' ? 'पासवर्ड पुष्टि गर्नुहोस्' : 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_languageService.currentLanguageCode == 'ne' ? 'रद्द गर्नुहोस्' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_languageService.currentLanguageCode == 'ne' ? 'पासवर्ड परिवर्तन गरियो' : 'Password changed')),
              );
            },
            child: Text(_languageService.currentLanguageCode == 'ne' ? 'परिवर्तन गर्नुहोस्' : 'Change'),
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_languageService.currentLanguageCode == 'ne' ? 'डेटा निर्यात सुरु भयो...' : 'Data export started...')),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_languageService.currentLanguageCode == 'ne' ? 'एप स्टोरमा रिडिरेक्ट गर्दै...' : 'Redirecting to app store...')),
    );
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_languageService.currentLanguageCode == 'ne' ? 'सहायता टिमसँग सम्पर्क गर्दै...' : 'Contacting support team...')),
    );
  }
}