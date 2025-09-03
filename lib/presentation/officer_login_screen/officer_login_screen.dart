import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/municipal_header_widget.dart';

class OfficerLoginScreen extends StatefulWidget {
  const OfficerLoginScreen({super.key});

  @override
  State<OfficerLoginScreen> createState() => _OfficerLoginScreenState();
}

class _OfficerLoginScreenState extends State<OfficerLoginScreen> {
  bool _loading = false, _nepali = false;
  String? _error;

  // ---- CONFIG ----
  static const _scheme = 'https';
  static const _host = 'uat.nirc.com.np';
  static const _port = 8443;

  // WORKING credential endpoint you provided
  static const _loginPath = '/GWP/user/login';

  String t(String np, String en) => _nepali ? np : en;

  Future<void> _login(String username, String password) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final u = username.trim();
    final p = password.trim();

    if (u.isEmpty || p.isEmpty) {
      setState(() => _error = t('कृपया प्रयोगकर्ता नाम र पासवर्ड भर्नुहोस्।',
          'Please enter username and password.'));
      _snack(_error!);
      setState(() => _loading = false);
      return;
    }

    try {
      final uri =
      Uri(scheme: _scheme, host: _host, port: _port, path: _loginPath);

      final resp = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': u, 'password': p}),
      )
          .timeout(const Duration(seconds: 15));

      // Attempt to parse JSON
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(resp.body) as Map<String, dynamic>?;
      } catch (_) {
        data = null;
      }

      if (resp.statusCode == 200 &&
          data != null &&
          (data['status']?.toString().toLowerCase() == 'success')) {
        HapticFeedback.lightImpact();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/officer-dashboard');
        return;
      }

      // Surface server message if any
      final serverMsg = (data?['message']?.toString().trim() ?? '');
      setState(() {
        _error = serverMsg.isNotEmpty
            ? t('लगइन अस्वीकार: $serverMsg', 'Login rejected: $serverMsg')
            : t('गलत प्रयोगकर्ता नाम वा पासवर्ड।',
            'Incorrect username or password.');
      });
      _snack(_error!);
      HapticFeedback.heavyImpact();
    } on TimeoutException {
      setState(() {
        _error = t('नेटवर्क ढिलो भयो। पुन: प्रयास गर्नुहोस्।',
            'Network timed out. Please try again.');
      });
      _snack(_error!);
      HapticFeedback.heavyImpact();
    } catch (e) {
      setState(() {
        _error = t('नेटवर्क समस्याको कारण लगइन असफल भयो।',
            'Login failed due to a network issue.');
      });
      _snack('${t("नेटवर्क त्रुटि", "Network error")}: $e');
      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  @override
  Widget build(BuildContext context) {
    final th = AppTheme.lightTheme, p = th.colorScheme.primary;

    return Scaffold(
      backgroundColor: th.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            MunicipalHeaderWidget(isNepali: _nepali),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _nepali = !_nepali;
                          _error = null;
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: p.withOpacity(0.1),
                            border: Border.all(color: p.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                  iconName: 'language', color: p, size: 16),
                              SizedBox(width: 1.w),
                              Text(
                                _nepali ? 'EN' : 'नेपाली',
                                style: th.textTheme.labelMedium?.copyWith(
                                  color: p,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    LoginFormWidget(
                      onLogin: _login,
                      isLoading: _loading,
                      errorMessage: _error,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: th.colorScheme.surface,
                        border: Border.all(color: th.dividerColor),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                  iconName: 'help_outline', color: p, size: 20),
                              SizedBox(width: 2.w),
                              Text(
                                t('सहायता चाहिन्छ?', 'Need Help?'),
                                style: th.textTheme.titleSmall?.copyWith(
                                  color: p,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            t(
                              'लगइन समस्या भएमा आफ्नो प्रशासकसँग सम्पर्क गर्नुहोस्।',
                              'For login issues, contact your administrator.',
                            ),
                            style: th.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: OutlinedButton.icon(
                    onPressed: _loading
                        ? null
                        : () => Navigator.pushReplacementNamed(
                        context, '/role-selection-screen'),
                    icon: CustomIconWidget(
                        iconName: 'arrow_back', color: p, size: 20),
                    label: Text(
                      t('फिर्ता जानुहोस्', 'Go Back'),
                      style: th.textTheme.labelLarge?.copyWith(
                        color: p,
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
