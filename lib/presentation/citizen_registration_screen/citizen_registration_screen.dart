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
        AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
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
      await Future.delayed(const Duration(seconds: 2));
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
      await Future.delayed(const Duration(seconds: 2));
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
    const String apiUrl = 'https://uat.nirc.com.np:8443/GWP/member/mobileLoginValidation';
    const String organizationId = '100'; // Set to ward ID 100 for testing
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
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
    // Navigate to citizen dashboard
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/citizen-dashboard');
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
  }

  void _showPrivacyNotice() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const PrivacyNoticeModal());
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Go Back?',
              style: TextStyle(fontSize: 20)),
          content: const Text(
              'Are you sure you want to go back to role selection?',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Go Back')),
          ],
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      _buildHeader(),
                      _buildWelcomeIllustration(),
                      _buildSocialAuthSection(),
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
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24,
              )),
          Expanded(
              child: Text('Join Bhadrapur Community',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                      fontSize: 20),
                  textAlign: TextAlign.center)),
          const SizedBox(width: 48),
        ]));
  }

  Widget _buildWelcomeIllustration() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 40000,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          const Text(
            'Welcome to Digital Bhadrapur',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          const Text(
            'Connect with your municipal services and make your voice heard in our community',
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialAuthSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          const Text(
            'Choose your preferred sign-in method',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          SocialAuthButton(
            provider: 'Google',
            icon: const Icon(Icons.g_translate, color: Colors.white),
            onPressed: _handleGoogleAuth,
            isLoading: _isGoogleLoading,
          ),
          SizedBox(height: 2.h),
          SocialAuthButton(
            provider: 'Facebook',
            icon: const Icon(Icons.facebook, color: Colors.white),
            onPressed: _handleFacebookAuth,
            isLoading: _isFacebookLoading,
          ),
          if (Theme.of(context).platform == TargetPlatform.iOS)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SocialAuthButton(
                provider: 'Apple',
                icon: const Icon(Icons.apple, color: Colors.white),
                onPressed: _handleAppleAuth,
                isLoading: _isAppleLoading,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.security,
              color: Colors.grey,
              size: 16,
            ),
            SizedBox(width: 2.w),
            const Text('Your data is secure with us',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14)),
          ]),
          SizedBox(height: 1.h),
          GestureDetector(
              onTap: _showPrivacyNotice,
              child: const Text('Read our Privacy Policy',
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      fontSize: 14))),
          SizedBox(height: 2.h),
          const Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy',
            style: TextStyle(
                color: Colors.grey,
                height: 1.4,
                fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ]));
  }
}

class SocialAuthButton extends StatelessWidget {
  final String provider;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialAuthButton({
    Key? key,
    required this.provider,
    this.icon,
    required this.onPressed,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon ?? const SizedBox.shrink(),
        label: isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(
          'Continue with $provider',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: provider == 'Google'
              ? Colors.red
              : provider == 'Facebook'
              ? const Color(0xFF4267B2)
              : provider == 'Apple'
              ? Colors.black
              : Colors.blue,
        ),
      ),
    );
  }
}