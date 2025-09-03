import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Additional properties that are being used in the app
  bool _isInitialized = false;
  Map<String, dynamic>? _userData;

  // Getters for the additional properties
  bool get isInitialized => _isInitialized;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _auth.currentUser != null;

  // Initialize the service
  Future<void> initialize() async {
    // Simulate initialization
    _isInitialized = true;
    // Load user data if user is already signed in
    if (_auth.currentUser != null) {
      _userData = {
        'userId': _auth.currentUser?.uid,
        'email': _auth.currentUser?.email,
        'displayName': _auth.currentUser?.displayName,
        'photoURL': _auth.currentUser?.photoURL,
      };
    }
  }

  // Cache user data
  Future<void> cacheUserData(User user) async {
    _userData = {
      'userId': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    };
  }

  // Get dashboard route based on user role
  String getDashboardRoute() {
    // Default to citizen dashboard
    return '/citizen-dashboard';
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      // Cache user data
      if (userCredential.user != null) {
        await cacheUserData(userCredential.user!);
      }
      
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _userData = null;
  }

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;
}