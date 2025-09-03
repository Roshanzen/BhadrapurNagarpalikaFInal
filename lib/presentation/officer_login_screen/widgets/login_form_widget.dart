import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String username, String password) onLogin;
  final bool isLoading;
  final String? errorMessage;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isNepali = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getLocalizedText(String nepali, String english) {
    return _isNepali ? nepali : english;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return _getLocalizedText(
          'प्रयोगकर्ता नाम आवश्यक छ', 'Username is required');
    }
    if (value.length < 3) {
      return _getLocalizedText('प्रयोगकर्ता नाम कम्तिमा ३ अक्षरको हुनुपर्छ',
          'Username must be at least 3 characters');
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _getLocalizedText('पासवर्ड आवश्यक छ', 'Password is required');
    }
    if (value.length < 6) {
      return _getLocalizedText('पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ',
          'Password must be at least 6 characters');
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_usernameController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Language Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isNepali = !_isNepali),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      _isNepali ? 'EN' : 'नेपाली',
                      style:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Form Title
            Text(
              _getLocalizedText('अधिकारी लगइन', 'Officer Login'),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            // Error Message
            widget.errorMessage != null
                ? Container(
              padding: EdgeInsets.all(2.w),
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: AppTheme.lightTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),

            // Username Field
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              validator: _validateUsername,
              decoration: InputDecoration(
                labelText: _getLocalizedText('प्रयोगकर्ता नाम', 'Username'),
                hintText: _getLocalizedText(
                    'आफ्नो प्रयोगकर्ता नाम प्रविष्ट गर्नुहोस्',
                    'Enter your username'),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              enabled: !widget.isLoading,
            ),
            SizedBox(height: 2.h),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: _getLocalizedText('पासवर्ड', 'Password'),
                hintText: _getLocalizedText(
                    'आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्', 'Enter your password'),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              enabled: !widget.isLoading,
            ),
            SizedBox(height: 1.h),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                  // Handle forgot password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _getLocalizedText(
                            'पासवर्ड रिसेट सुविधा छिट्टै उपलब्ध हुनेछ',
                            'Password reset feature coming soon'),
                      ),
                    ),
                  );
                },
                child: Text(
                  _getLocalizedText('पासवर्ड बिर्सनुभयो?', 'Forgot Password?'),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Login Button
            SizedBox(
              height: 6.h,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _handleLogin,
                child: widget.isLoading
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getLocalizedText('लगइन गर्दै...', 'Logging in...'),
                      style: AppTheme.lightTheme.textTheme.labelLarge
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
                    : Text(
                  _getLocalizedText('लगइन', 'Login'),
                  style:
                  AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
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
