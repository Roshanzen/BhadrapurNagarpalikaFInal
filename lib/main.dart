import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import '../../services/google_signin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());

  // Initialize Facebook Auth
  await FacebookAuth.instance.webAndDesktopInitialize(
    appId: "859204013459962",
    cookie: true,
    xfbml: true,
    version: "v17.0",
  );

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isGoogleLoading = false; // State for loading

  // Google Authentication Handler
  Future<void> _handleGoogleAuth() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? account = await GoogleSignInService.signIn();
      if (account == null) {
        _showErrorSnackBar('Google sign-in cancelled.');
        return;
      }

      // Authenticate with Firebase using the Google account
      final user = await GoogleSignInService.firebaseSignInWithGoogle(account);
      if (user == null) {
        _showErrorSnackBar('Firebase sign-in failed.');
        return;
      }

      // Proceed with the rest of your logic (e.g., save user info, call backend)
      _showWardSelectionModal();
    } catch (e) {
      _showErrorSnackBar('Google authentication failed: $e');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  // Function to show error snack bar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Function to show ward selection modal (replace with actual modal logic)
  void _showWardSelectionModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ward Selection'),
        content: Text('Select your ward.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'bhadrapur_',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
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
        home: Scaffold(
          appBar: AppBar(title: Text("Google Sign-In Example")),
          body: Center(
            child: _isGoogleLoading
                ? CircularProgressIndicator() // Show loading indicator while signing in
                : ElevatedButton(
              onPressed: _handleGoogleAuth,
              child: Text('Sign In with Google'),
            ),
          ),
        ),
      );
    });
  }
}
