// lib/services/google_signin_service.dart

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInService {
  static const String _androidServerClientId =
      '902022025384-5cs1cclq5qib2hfvjf84vhpucdamoopv.apps.googleusercontent.com';
  static const String? _iosClientId = null;

  static final GoogleSignIn _instance = GoogleSignIn(
    scopes: const ['email', 'profile'],
    clientId: _iosClientId,
    serverClientId: Platform.isAndroid ? _androidServerClientId : null,
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _instance.signIn();
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }

  static Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _instance.signInSilently();
    } catch (e) {
      debugPrint('Google Silent Sign-In error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _instance.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  static GoogleSignInAccount? get currentUser => _instance.currentUser;

  static Future<Map<String, String>?> getAuth(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication auth = await account.authentication;
      return {
        'idToken': auth.idToken ?? '',
        'accessToken': auth.accessToken ?? '',
      };
    } catch (e) {
      debugPrint('Get Auth error: $e');
      return null;
    }
  }

  static Future<User?> firebaseSignInWithGoogle(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication tokens = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: tokens.idToken,
        accessToken: tokens.accessToken,
      );
      final UserCredential uc =
      await FirebaseAuth.instance.signInWithCredential(credential);
      return uc.user;
    } catch (e) {
      debugPrint("Firebase Sign-In Error: $e");
      return null;
    }
  }
}