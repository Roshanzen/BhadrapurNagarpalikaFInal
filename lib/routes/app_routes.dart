import 'package:flutter/material.dart';
import '../presentation/officer_dashboard/officer_dashboard.dart';
import '../presentation/officer_login_screen/officer_login_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/citizen_dashboard/citizen_dashboard.dart';
import '../presentation/citizen_registration_screen/citizen_registration_screen.dart';
import '../presentation/role_selection_screen/role_selection_screen.dart';
import '../presentation/complaint_submission_form/complaint_submission_form.dart';
import '../presentation/complaint_detail_view/complaint_detail_view.dart';
import '../presentation/notice_board_management/notice_board_management.dart';
import '../presentation/gunaso_form/widgets/pending_work_page.dart';
import '../presentation/gunaso_form/widgets/under_review_page.dart';
import '../presentation/gunaso_form/widgets/completed_complaints_page.dart';
import '../presentation/profile_pages/settings_page.dart';
import '../presentation/profile_pages/help_page.dart';
import '../presentation/profile_pages/about_us_page.dart';
import '../presentation/profile_pages/address_change_page.dart';
import '../presentation/profile_pages/privacy_policy_page.dart';
import '../presentation/language_selection_screen/language_selection_screen.dart';

class AppRoutes {
  // Route names
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String officerDashboard = '/officer-dashboard';
  static const String officerLogin = '/officer-login-screen';
  static const String officerLoginAlt = '/officer-login'; // Alternative route name
  static const String citizenDashboard = '/citizen-dashboard';
  static const String citizenRegistration = '/citizen-registration-screen';
  static const String roleSelection = '/role-selection-screen';
  static const String complaintSubmissionForm = '/complaint-submission-form';
  static const String complaintDetailView = '/complaint-detail-view';
  static const String noticeBoardManagement = '/notice-board-management';
  static const String pendingWork = '/pending-work';
  static const String underReview = '/under-review';
  static const String completedComplaints = '/completed-complaints';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String about = '/about';
  static const String addressChange = '/address-change';
  static const String privacy = '/privacy';
  static const String languageSelection = '/language-selection';

  // Route map
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    officerDashboard: (context) => const OfficerDashboard(),
    officerLogin: (context) => const OfficerLoginScreen(),
    officerLoginAlt: (context) => const OfficerLoginScreen(), // Alternative route
    citizenDashboard: (context) => const CitizenDashboard(),
    citizenRegistration: (context) => const CitizenRegistrationScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    complaintSubmissionForm: (context) => const ComplaintSubmissionForm(),
    complaintDetailView: (context) => const ComplaintDetailView(),
    noticeBoardManagement: (context) => const NoticeBoardManagement(),
    pendingWork: (context) => PendingWorkPage(),
    underReview: (context) => UnderReviewPage(),
    completedComplaints: (context) => CompletedComplaintsPage(),
    settings: (context) => const SettingsPage(),
    help: (context) => const HelpPage(),
    about: (context) => const AboutUsPage(),
    addressChange: (context) => const AddressChangePage(),
    privacy: (context) => const PrivacyPolicyPage(),
    languageSelection: (context) => const LanguageSelectionScreen(),
  };
}
