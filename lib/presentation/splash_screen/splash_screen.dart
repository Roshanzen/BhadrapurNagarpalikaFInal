import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../services/auth_service.dart';
import '../citizen_dashboard/citizen_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
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
    _logoAnimationController.forward();

    await _checkNetworkConnectivity();
    await _loadBilingualContent();
    await _prepareCachedData();
    await _validateStoredCredentials();

    await Future.delayed(const Duration(milliseconds: 800));
    _textAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 3200));

    HapticFeedback.lightImpact();
    _navigateToNextScreen();
  }

  Future<void> _checkNetworkConnectivity() async {
    setState(() {
      _loadingStatus = 'नेटवर्क जाँच गर्दै...';
    });
    try {
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

    try {
      final authService = AuthService();
      if (!authService.isInitialized) {
        await authService.initialize();
      }

      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        _isLoading = false;
        _loadingStatus = 'तयार छ!';
      });
    } catch (e) {
      debugPrint('Error validating credentials: $e');
      setState(() {
        _isLoading = false;
        _loadingStatus = 'तयार छ!';
      });
    }
  }

  void _navigateToNextScreen() {
    final authService = AuthService();

    debugPrint('Navigation check - AuthService initialized: ${authService.isInitialized}');
    debugPrint('Navigation check - Current user: ${authService.currentUser?.email ?? 'null'}');
    debugPrint('Navigation check - Cached user data: ${authService.userData}');
    debugPrint('Navigation check - Is logged in: ${authService.isLoggedIn}');

    if (authService.isLoggedIn && authService.userData != null) {
      final userData = {
        'displayName': authService.userData!['displayName'] ??
            authService.userData!['name'] ??
            'नागरिक',
        'email': authService.userData!['email'] ?? '',
        'photoUrl': authService.userData!['photoURL'] ?? authService.userData!['photoUrl'],
        'localId': authService.userData!['userId'] ?? '',
        'firstName': authService.userData!['firstName'] ?? '',
        'lastName': authService.userData!['lastName'] ?? '',
      };

      debugPrint('✅ User authenticated, navigating to CitizenDashboard');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CitizenDashboard(googleUserData: userData),
        ),
      );
    } else {
      debugPrint('❌ User not authenticated, navigating to role selection');
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: const AssetImage('assets/images/logo.png'),
                            backgroundColor: Colors.transparent,
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
                              'भद्रपुर नगरपालिकाको गुनासो पोर्टलमा\nयहाँहरूलाई स्वागत छ',
                              textAlign: TextAlign.center,
                              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                height: 1.5,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 9,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
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
                          Colors.white,
                        ),
                        strokeWidth: 3.0,
                      )
                          : const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _loadingStatus,
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!_hasNetworkConnection && !_isLoading) ...[
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              color: Colors.white54,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'अफलाइन मोडमा काम गर्दै',
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Version Info
                Text(
                  'संस्करण १.०.०',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
