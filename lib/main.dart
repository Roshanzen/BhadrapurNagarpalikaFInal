import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app_export.dart';
import 'widgets/custom_error_widget.dart';
import 'widgets/language_wrapper.dart';
import 'services/auth_service.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Initialize Auth Service
    final authService = AuthService();
    await authService.initialize();
    print('AuthService initialized successfully');

    // Initialize Language Service
    final languageService = LanguageService();
    await languageService.initialize();
    print('LanguageService initialized successfully');

  } catch (e) {
    print('Service initialization error: $e');
  }

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    LanguageWrapper(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'bhadrapur_',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}
