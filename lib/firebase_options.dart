import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:web:cf2f94aa2312df7197f29d',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    authDomain: 'bhadrapur-nagarpalika-bc1fb.firebaseapp.com',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
    measurementId: 'G-MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:android:6fe45903e0245de297f29d',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:ios:tt75l6b4ikfpvkn9kvkelcorhdm5hik0',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
    iosBundleId: 'com.example.bhadrapurNagarpalika',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:macos:tt75l6b4ikfpvkn9kvkelcorhdm5hik0',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:windows:tt75l6b4ikfpvkn9kvkelcorhdm5hik0',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDwQiAQhUg8IA9BfcKh1N_ejgIxC1yB73o',
    appId: '1:902022025384:linux:tt75l6b4ikfpvkn9kvkelcorhdm5hik0',
    messagingSenderId: '902022025384',
    projectId: 'bhadrapur-nagarpalika-bc1fb',
    storageBucket: 'bhadrapur-nagarpalika-bc1fb.firebasestorage.app',
  );
}