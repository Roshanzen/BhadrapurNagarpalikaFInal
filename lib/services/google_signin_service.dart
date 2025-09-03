// lib/services/google_signin_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_service.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? null : null, // Web uses different client ID
    scopes: ['email', 'profile'],
  );

  // Sign in method - handles both web and mobile
  static Future<Map<String, dynamic>?> signIn() async {
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

        if (userCredential.user != null) {
          return {
            'user': userCredential.user,
            'displayName': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'photoUrl': userCredential.user!.photoURL,
            'localId': userCredential.user!.uid,
            'firstName': userCredential.user!.displayName?.split(' ').first,
            'lastName': userCredential.user!.displayName?.split(' ').last,
          };
        }
        return null;
      } else {
        // For mobile, use Google Sign-In package with better error handling
        debugPrint('Starting Google Sign-In process...');

        // Check if Google Play Services are available
        final GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
        if (currentUser != null) {
          debugPrint('User already signed in: ${currentUser.email}');
          // Sign out first to allow account selection
          await _googleSignIn.signOut();
        }

        debugPrint('Showing Google Sign-In account picker...');
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          debugPrint('Google Sign-In cancelled by user - no account selected');
          return null;
        }

        debugPrint('Google account selected: ${googleUser.email}');
        debugPrint('Getting authentication details...');

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          debugPrint('Failed to get authentication tokens');
          return null;
        }

        debugPrint('Creating Firebase credential...');

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        debugPrint('Signing in with Firebase...');

        // Once signed in, return the UserCredential
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          debugPrint('Google Sign-In successful for: ${userCredential.user!.email}');

          // Cache user data using AuthService
          final authService = AuthService();
          if (authService.isInitialized) {
            await authService.cacheUserData(userCredential.user!);
          }

          return {
            'user': userCredential.user,
            'displayName': googleUser.displayName,
            'email': googleUser.email,
            'photoUrl': googleUser.photoUrl,
            'localId': userCredential.user!.uid,
            'firstName': googleUser.displayName?.split(' ').first,
            'lastName': googleUser.displayName?.split(' ').last,
          };
        }

        debugPrint('Firebase authentication failed');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Google Sign-In error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Handle specific error types
      String errorMessage = e.toString();

      if (errorMessage.contains('sign_in_cancelled')) {
        debugPrint('❌ User cancelled the sign-in process');
      } else if (errorMessage.contains('ApiException: 10')) {
        debugPrint('❌ DEVELOPER_ERROR (ApiException: 10)');
        debugPrint('   This usually means:');
        debugPrint('   1. SHA-1 fingerprint not added to Firebase Console');
        debugPrint('   2. Package name mismatch');
        debugPrint('   3. OAuth client ID configuration issue');
        debugPrint('   SOLUTION: Add SHA-1 fingerprint to Firebase Console');
      } else if (errorMessage.contains('network_error')) {
        debugPrint('❌ Network error during sign-in');
      } else if (errorMessage.contains('play_services')) {
        debugPrint('❌ Google Play Services error');
      } else if (errorMessage.contains('sign_in_failed')) {
        debugPrint('❌ Sign-in failed - check Firebase configuration');
      }

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

      // Clear cached user data using AuthService
      final authService = AuthService();
      if (authService.isInitialized) {
        await authService.signOut();
      }

      debugPrint('Successfully signed out and cleared cache');
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
static Future<Map<String, dynamic>?> signInWithGoogle() async {
  return await signIn();
}
}

