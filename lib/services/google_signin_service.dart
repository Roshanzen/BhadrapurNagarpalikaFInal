// lib/services/google_signin_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInService {
  // Client ID specific to your app and platform (Android or iOS)
  static const String _androidServerClientId =
      '902022025384-5cs1cclq5qib2hfvjf84vhpucdamoopv.apps.googleusercontent.com';
  static const String _iosClientId =
      'your-ios-client-id.apps.googleusercontent.com';  // Replace with actual iOS client ID

  // Sign in method - handles both web and mobile
  static Future<User?> signIn() async {
    try {
      if (kIsWeb) {
        // For web, use Firebase Auth with Google provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({
          'prompt': 'select_account'
        });

        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // For mobile, use a simplified approach
        // We'll use Firebase Auth with Google provider for mobile too
        // to avoid platform-specific issues
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithProvider(googleProvider);
        return userCredential.user;
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }

  // Silent sign-in method (without user interaction)
  static Future<User?> signInSilently() async {
    try {
      // Check if user is already signed in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return currentUser;
      }

      // For web, try to restore authentication state
      if (kIsWeb) {
        try {
          // On web, Firebase Auth handles persistence automatically
          await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
          return FirebaseAuth.instance.currentUser;
        } catch (e) {
          debugPrint('Web silent sign-in error: $e');
        }
      }

      return null;
    } catch (e) {
      debugPrint('Silent Sign-In error: $e');
      return null;
    }
  }

  // Sign-out method
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('Successfully signed out');
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // Get the current signed-in user
  static User? get currentUser => FirebaseAuth.instance.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => FirebaseAuth.instance.currentUser != null;

  // Listen to authentication state changes
  static Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
// Main sign-in method that handles both platforms
static Future<User?> signInWithGoogle() async {
  return await signIn();
}
}

