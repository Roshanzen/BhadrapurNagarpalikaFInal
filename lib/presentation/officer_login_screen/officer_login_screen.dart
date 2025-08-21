import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/municipal_header_widget.dart';

class OfficerLoginScreen extends StatefulWidget {
  const OfficerLoginScreen({Key? key}) : super(key: key);

  @override
  State<OfficerLoginScreen> createState() => _OfficerLoginScreenState();
}

class _OfficerLoginScreenState extends State<OfficerLoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isNepali = false;

  // Mock credentials for demonstration
  final Map<String, String> _mockCredentials = {
    'officer1': 'password123',
    'admin': 'admin123',
    'municipal_officer': 'officer@123',
  };

  String _getLocalizedText(String nepali, String english) {
    return _isNepali ? nepali : english;
  }

  Future<void> _handleLogin(String username, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock authentication logic
    if (_mockCredentials.containsKey(username) &&
        _mockCredentials[username] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to officer dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/officer-dashboard');
      }
    } else {
      // Authentication failed
      setState(() {
        _errorMessage = _getLocalizedText(
            'गलत प्रयोगकर्ता नाम वा पासवर्ड। कृपया पुन: प्रयास गर्नुहोस्।',
            'Invalid username or password. Please try again.');
      });
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isNepali = !_isNepali;
      _errorMessage = null; // Clear error message when language changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Municipal Header
            MunicipalHeaderWidget(isNepali: _isNepali),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4.h),

                      // Language Toggle Button (Top Right)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: _toggleLanguage,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3.w),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'language',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      _isNepali ? 'EN' : 'नेपाली',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                        errorMessage: _errorMessage,
                      ),
                      SizedBox(height: 4.h),

                      // Help Section
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.dividerColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'help_outline',
                                  color:
                                  AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  _getLocalizedText(
                                      'सहायता चाहिन्छ?', 'Need Help?'),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color:
                                    AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _getLocalizedText(
                                  'लगइन समस्या भएमा आफ्नो प्रशासकसँग सम्पर्क गर्नुहोस् वा IT विभागमा फोन गर्नुहोस्।',
                                  'For login issues, contact your administrator or call the IT department.'),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _getLocalizedText('डेमो: officer1/password123',
                                  'Demo: officer1/password123'),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Back Button
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
                      Navigator.pushReplacementNamed(
                          context, '/role-selection-screen');
                    },
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text(
                      _getLocalizedText('फिर्ता जानुहोस्', 'Go Back'),
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
