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

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String officerDashboard = '/officer-dashboard';
  static const String officerLogin = '/officer-login-screen';
  static const String splash = '/splash-screen';
  static const String citizenDashboard = '/citizen-dashboard';
  static const String citizenRegistration = '/citizen-registration-screen';
  static const String roleSelection = '/role-selection-screen';
  static const String complaintSubmissionForm = '/complaint-submission-form';
  static const String complaintDetailView = '/complaint-detail-view';
  static const String noticeBoardManagement = '/notice-board-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    officerDashboard: (context) => const OfficerDashboard(),
    officerLogin: (context) => const OfficerLoginScreen(),
    splash: (context) => const SplashScreen(),
    citizenDashboard: (context) => const CitizenDashboard(),
    citizenRegistration: (context) => const CitizenRegistrationScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    complaintSubmissionForm: (context) => const ComplaintSubmissionForm(),
    complaintDetailView: (context) => const ComplaintDetailView(),
    noticeBoardManagement: (context) => const NoticeBoardManagement(),
    // TODO: Add your other routes here
  };
}
