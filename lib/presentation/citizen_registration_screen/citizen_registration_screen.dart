import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/privacy_notice_modal.dart';
import './widgets/social_auth_button.dart';
import './widgets/ward_selection_modal.dart';

class CitizenRegistrationScreen extends StatefulWidget {
  const CitizenRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<CitizenRegistrationScreen> createState() => _CitizenRegistrationScreenState();
}

class _CitizenRegistrationScreenState extends State<CitizenRegistrationScreen>
    with TickerProviderStateMixin {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isAppleLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleAuth() async {
    setState(() => _isGoogleLoading = true);

    try {
      // Simulate Google OAuth flow
      await Future.delayed(Duration(seconds: 2));

      // Show success feedback
      HapticFeedback.lightImpact();

      // Show ward selection modal
      _showWardSelectionModal();
    } catch (e) {
      _showErrorSnackBar('Google authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleFacebookAuth() async {
    setState(() => _isFacebookLoading = true);

    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'], // Request email and basic profile
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        // Fetch user data
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,id",
        );

        final String facebookId = userData['id'];
        final String fullName = userData['name'];
        final String? emailAddress = userData['email']; // May be null if not granted

        // Call backend to verify/create user
        await _callBackendApi(facebookId, fullName, emailAddress);

        // Show success feedback
        HapticFeedback.lightImpact();

        // Show ward selection modal
        _showWardSelectionModal();
      } else {
        throw Exception('Facebook login failed: ${result.message}');
      }
    } catch (e) {
      _showErrorSnackBar('Facebook authentication failed: $e. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

  Future<void> _handleAppleAuth() async {
    setState(() => _isAppleLoading = true);

    try {
      // Simulate Apple OAuth flow
      await Future.delayed(Duration(seconds: 2));

      // Show success feedback
      HapticFeedback.lightImpact();

      // Show ward selection modal
      _showWardSelectionModal();
    } catch (e) {
      _showErrorSnackBar('Apple authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isAppleLoading = false);
      }
    }
  }

  // New method to call backend API
  Future<void> _callBackendApi(String facebookId, String fullName, String? emailAddress) async {
    final String apiUrl = 'https://uat.nirc.com.np:8443/GWP/member/mobileLoginValidation';
    final String organizationId = '100'; // Set to ward ID 100 for testing

    try {
      final response = await Dio().post(
        apiUrl,
        data: {
          'facebookId': facebookId,
          'fullName': fullName,
          'emailAddress': emailAddress ?? 'not_provided',
          'organization': organizationId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Ensure the content type is set
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse['statusCode'] == 200 && jsonResponse['success'] == true) {
          // Optionally store user data (e.g., memberId) in shared_preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('memberId', jsonResponse['data'][0]['memberId'].toString());
          await prefs.setString('memberName', jsonResponse['data'][0]['memberName']);
          await prefs.setString('facebookId', jsonResponse['data'][0]['facebookId']);
          await prefs.setString('orgId', jsonResponse['data'][0]['orgId'].toString()); // Store orgId
        } else {
          throw Exception(jsonResponse['message'] ?? 'Backend verification failed');
        }
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  void _showWardSelectionModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WardSelectionModal(onWardSelected: (wardNumber) {
              _handleWardSelection(wardNumber);
            }));
  }

  void _handleWardSelection(int wardNumber) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration successful! Welcome to Ward $wardNumber'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));

    // Navigate to citizen dashboard
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/citizen-dashboard');
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
  }

  void _showPrivacyNotice() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PrivacyNoticeModal());
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Go Back?',
                      style: AppTheme.lightTheme.textTheme.titleLarge),
                  content: Text(
                      'Are you sure you want to go back to role selection?',
                      style: AppTheme.lightTheme.textTheme.bodyMedium),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Go Back')),
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Container(
                  width: 100.w,
                  child: Column(
                    children: [
                      // Header section
                      _buildHeader(),

                      // Welcome illustration
                      _buildWelcomeIllustration(),

                      // Social authentication buttons
                      _buildSocialAuthSection(),

                      // Divider
                      _buildDivider(),

                      // Manual registration option
                      _buildManualRegistrationOption(),

                      // Privacy notice
                      _buildPrivacyNotice(),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24)),
          Expanded(
              child: Text('Join Bhadrapur Community',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary),
                  textAlign: TextAlign.center)),
          SizedBox(width: 48), // Balance the back button
        ]));
  }

  Widget _buildWelcomeIllustration() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Column(children: [
          // Municipal logo and community illustration
          Container(
              width: 40.w,
              height: 20.h,
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      width: 2)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                        iconName: 'location_city',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48),
                    SizedBox(height: 1.h),
                    Text('भद्रपुर',
                        style: AppTheme.lightTheme.textTheme.titleLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.colorScheme.primary)),
                    Text('नगरपालिका',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.lightTheme.colorScheme.primary)),
                  ])),

          SizedBox(height: 3.h),

          // Welcome message
          Text('Welcome to Digital Bhadrapur',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface),
              textAlign: TextAlign.center),

          SizedBox(height: 1.h),

          Text(
              'Connect with your municipal services and make your voice heard in our community',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.5),
              textAlign: TextAlign.center),
        ]));
  }

  Widget _buildSocialAuthSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(children: [
          Text('Choose your preferred sign-in method',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),

          SizedBox(height: 3.h),

          // Google authentication
          SocialAuthButton(
              provider: 'Google',
              iconName: 'account_circle',
              onPressed: _handleGoogleAuth,
              isLoading: _isGoogleLoading),

          // Facebook authentication
          SocialAuthButton(
              provider: 'Facebook',
              iconName: 'facebook',
              onPressed: _handleFacebookAuth,
              isLoading: _isFacebookLoading),

          // Apple authentication (iOS only)
          if (Theme.of(context).platform == TargetPlatform.iOS)
            SocialAuthButton(
                provider: 'Apple',
                iconName: 'apple',
                onPressed: _handleAppleAuth,
                isLoading: _isAppleLoading),
        ]));
  }

  Widget _buildDivider() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Row(children: [
          Expanded(
              child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                  thickness: 1)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text('OR',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500))),
          Expanded(
              child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                  thickness: 1)),
        ]));
  }

  Widget _buildManualRegistrationOption() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: OutlinedButton(
            onPressed: () {
              // Navigate to manual registration form
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Manual registration feature coming soon!'),
                  behavior: SnackBarBehavior.floating));
            },
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20),
              SizedBox(width: 2.w),
              Text('Register with Email',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.primary)),
            ])));
  }

  Widget _buildPrivacyNotice() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16),
            SizedBox(width: 2.w),
            Text('Your data is secure with us',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          ]),
          SizedBox(height: 1.h),
          GestureDetector(
              onTap: _showPrivacyNotice,
              child: Text('Read our Privacy Policy',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500))),
          SizedBox(height: 2.h),
          Text(
              'By continuing, you agree to our Terms of Service and Privacy Policy',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.4),
              textAlign: TextAlign.center),
        ]));
  }
}