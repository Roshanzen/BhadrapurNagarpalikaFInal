import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;

  bool _isLoading = true;
  bool _hasNetworkConnection = false;
  String _loadingStatus = 'प्रारम्भ गर्दै...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSplashSequence() async {
    // Start logo animation
    _logoAnimationController.forward();

    // Check network connectivity
    await _checkNetworkConnectivity();

    // Load bilingual content
    await _loadBilingualContent();

    // Prepare cached data
    await _prepareCachedData();

    // Validate stored credentials
    await _validateStoredCredentials();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textAnimationController.forward();

    // Complete splash after 5 seconds total
    await Future.delayed(const Duration(milliseconds: 3200));

    // Haptic feedback on completion
    HapticFeedback.lightImpact();

    // Navigate based on authentication status
    _navigateToNextScreen();
  }

  Future<void> _checkNetworkConnectivity() async {
    setState(() {
      _loadingStatus = 'नेटवर्क जाँच गर्दै...';
    });

    try {
      // Simulate network check
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _hasNetworkConnection = true;
        _loadingStatus = 'सामग्री लोड गर्दै...';
      });
    } catch (e) {
      setState(() {
        _hasNetworkConnection = false;
        _loadingStatus = 'अफलाइन मोड...';
      });
    }
  }

  Future<void> _loadBilingualContent() async {
    setState(() {
      _loadingStatus = 'भाषा सामग्री तयार गर्दै...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _prepareCachedData() async {
    setState(() {
      _loadingStatus = 'डाटा तयार गर्दै...';
    });

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _validateStoredCredentials() async {
    setState(() {
      _loadingStatus = 'प्रमाणीकरण जाँच गर्दै...';
    });

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _isLoading = false;
      _loadingStatus = 'तयार छ!';
    });
  }

  void _navigateToNextScreen() {
    // Check for stored authentication
    bool hasOfficerAuth = false; // This would check actual stored credentials
    bool hasCitizenAuth = false; // This would check actual stored credentials

    if (hasOfficerAuth) {
      Navigator.pushReplacementNamed(context, '/officer-dashboard');
    } else if (hasCitizenAuth) {
      Navigator.pushReplacementNamed(context, '/citizen-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/role-selection-screen');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'account_balance',
                                  color:
                                  AppTheme.lightTheme.colorScheme.primary,
                                  size: 12.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'भद्रपुर',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color:
                                    AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'नगरपालिका',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontSize: 6.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Welcome Message Section
              Expanded(
                flex: 1,
                child: AnimatedBuilder(
                  animation: _textFadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textFadeAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'स्वागत छ',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'भद्रपुर नगरपालिका गुनासो पोर्टलमा',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.9),
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                      strokeWidth: 3.0,
                    )
                        : CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 8.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _loadingStatus,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!_hasNetworkConnection && !_isLoading) ...[
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'wifi_off',
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.6),
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'अफलाइन मोडमा काम गर्दै',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.6),
                              fontSize: 8.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Version Info
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'संस्करण १.०.०',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.5),
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
