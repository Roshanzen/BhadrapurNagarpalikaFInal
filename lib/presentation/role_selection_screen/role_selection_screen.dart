import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../services/language_service.dart';
import './widgets/help_bottom_sheet_widget.dart';
import './widgets/language_toggle_widget.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late LanguageService _languageService;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _languageService = LanguageService();
    _languageService.addListener(_onLanguageChanged);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _toggleLanguage() {
    _languageService.toggleLanguage();
    HapticFeedback.lightImpact();
  }

  void _showHelpBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HelpBottomSheetWidget(isNepali: _languageService.isNepali),
    );
  }

  void _goToOfficerLogin() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, "/officer-login-screen");
  }

  void _goToCitizenLogin() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, "/citizen-registration-screen");
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            _languageService.isNepali ? "एप बन्द गर्नुहुन्छ?" : "Exit App?",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            _languageService.isNepali
                ? "के तपाईं भद्रपुर नगरपालिका गुनासो पोर्टल बन्द गर्न चाहनुहुन्छ?"
                : "Do you want to exit Bhadrapur Nagarpalika Complaint Portal?",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                _languageService.isNepali ? "रद्द गर्नुहोस्" : "Cancel",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
              child: Text(
                _languageService.isNepali ? "बाहिर निस्कनुहोस्" : "Exit",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // 🚀 disables the back button
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          elevation: 0,
          title: Row(
            children: [
              LanguageToggleWidget(
                isNepali: _languageService.isNepali,
                onToggle: _toggleLanguage,
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: _showHelpBottomSheet,
                child: const Icon(Icons.help_outline, color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _goToOfficerLogin,
              child: Text(
                _languageService.isNepali ? "कार्यालय लग इन" : "Officer Login",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: SafeArea(
          child: Container(
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _languageService.isNepali
                              ? "भद्रपुर नगरपालिका"
                              : "Bhadrapur Nagarpalika",
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _languageService.isNepali
                              ? "गुनासो व्यवस्थापन पोर्टल"
                              : "Complaint Management Portal",
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _goToCitizenLogin,
                    child: Text(
                      _languageService.isNepali
                          ? "नागरिक लग इन"
                          : "Citizen Login",
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
