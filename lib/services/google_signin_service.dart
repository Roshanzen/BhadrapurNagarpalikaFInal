import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  // Web client ID (required for web)
  static const String _webClientId =
      '414690786328-6ffv882ffbmr36qrnhjarrenvk38u0q6.apps.googleusercontent.com';

  // Android server client ID (for ID token, optional)
  static const String _androidServerClientId =
      '414690786328-6ffv882ffbmr36qrnhjarrenvk38u0q6.apps.googleusercontent.com';

  // iOS client ID (optional)
  static const String? _iosClientId = null;

  // Initialize the GoogleSignIn instance
  static final GoogleSignIn _instance = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: kIsWeb ? _webClientId : _iosClientId,
    serverClientId: !kIsWeb && Platform.isAndroid ? _androidServerClientId : null,
  );

  /// Trigger Google Sign-In
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _instance.signIn();
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  /// Sign in silently (if user already signed in)
  static Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _instance.signInSilently();
    } catch (_) {
      return null;
    }
  }

  /// Get auth tokens (accessToken + idToken)
  static Future<GoogleSignInAuthentication?> getAuth(GoogleSignInAccount account) async {
    try {
      return await account.authentication;
    } catch (_) {
      return null;
    }
  }

  /// Sign out
  static Future<void> signOut() async => await _instance.signOut();

  /// Current user
  static GoogleSignInAccount? get currentUser => _instance.currentUser;
}
