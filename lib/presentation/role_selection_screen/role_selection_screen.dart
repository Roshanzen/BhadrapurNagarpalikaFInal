import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/help_bottom_sheet_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/role_card_widget.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  bool _isNepali = true;
  int _selectedRole = -1;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _roleData = [
    {
      "titleNepali": "कार्यालय",
      "titleEnglish": "Karyalaya",
      "subtitleNepali": "अधिकारी लगइन",
      "subtitleEnglish": "Officer Login",
      "descriptionNepali":
      "नगरपालिकाका अधिकारीहरूका लागि गुनासो व्यवस्थापन प्रणाली",
      "descriptionEnglish":
      "Complaint management system for municipal officers",
      "icon": "badge",
      "route": "/officer-login-screen",
    },
    {
      "titleNepali": "जनता",
      "titleEnglish": "Janta",
      "subtitleNepali": "नागरिक लगइन",
      "subtitleEnglish": "Citizen Login",
      "descriptionNepali": "स्थानीय नागरिकहरूका लागि गुनासो दर्ता र ट्र्याकिङ",
      "descriptionEnglish":
      "Complaint registration and tracking for local citizens",
      "icon": "people",
      "route": "/citizen-registration-screen",
    },
  ];

  @override
  void initState() {
    super.initState();
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
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    setState(() {
      _isNepali = !_isNepali;
    });
    HapticFeedback.lightImpact();
  }

  void _showHelpBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HelpBottomSheetWidget(isNepali: _isNepali),
    );
  }

  void _selectRole(int index) {
    setState(() {
      _selectedRole = index;
    });
    HapticFeedback.selectionClick();

    // Navigate after brief delay for visual feedback
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushNamed(context, _roleData[index]["route"]);
      }
    });
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
            _isNepali ? "एप बन्द गर्नुहुन्छ?" : "Exit App?",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            _isNepali
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
                _isNepali ? "रद्द गर्नुहोस्" : "Cancel",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: Text(
                _isNepali ? "बाहिर निस्कनुहोस्" : "Exit",
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
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header with language toggle and help
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LanguageToggleWidget(
                        isNepali: _isNepali,
                        onToggle: _toggleLanguage,
                      ),
                      GestureDetector(
                        onTap: _showHelpBottomSheet,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.shadow
                                    .withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'help_outline',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Logo and title section
                Expanded(
                  flex: 2,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'account_balance',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 12.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          _isNepali
                              ? "भद्रपुर नगरपालिका"
                              : "Bhadrapur Nagarpalika",
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _isNepali
                              ? "गुनासो व्यवस्थापन पोर्टल"
                              : "Complaint Management Portal",
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Role selection cards
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        _isNepali
                            ? "आफ्नो भूमिका छान्नुहोस्"
                            : "Select Your Role",
                        style:
                        AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          itemCount: _roleData.length,
                          itemBuilder: (context, index) {
                            final role = _roleData[index];
                            return AnimatedContainer(
                              duration:
                              Duration(milliseconds: 200 + (index * 100)),
                              child: RoleCardWidget(
                                roleTitle: _isNepali
                                    ? role["titleNepali"]
                                    : role["titleEnglish"],
                                roleSubtitle: _isNepali
                                    ? role["subtitleNepali"]
                                    : role["subtitleEnglish"],
                                roleDescription: _isNepali
                                    ? role["descriptionNepali"]
                                    : role["descriptionEnglish"],
                                iconName: role["icon"],
                                isSelected: _selectedRole == index,
                                onTap: () => _selectRole(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Need Help section
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: GestureDetector(
                    onTap: _showHelpBottomSheet,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'support_agent',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            _isNepali ? "सहायता चाहिन्छ?" : "Need Help?",
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
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
