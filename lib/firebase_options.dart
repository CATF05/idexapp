
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5VZA8jhMSs1q6kuCTNr-ZQ5xk5gtthNU',
    appId: '1:1036910535170:web:f7997052765d5e02833d1b',
    messagingSenderId: '1036910535170',
    projectId: 'idexapp-9d3de',
    authDomain: 'idexapp-9d3de.firebaseapp.com',
    storageBucket: 'idexapp-9d3de.firebasestorage.app',
    measurementId: 'G-6S4GQ85G89',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHWq9ue4mPOoYMBOFAD-PgRAcN5q6aRBg',
    appId: '1:1036910535170:android:8907542636a23aeb833d1b',
    messagingSenderId: '1036910535170',
    projectId: 'idexapp-9d3de',
    storageBucket: 'idexapp-9d3de.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhmosTs1O1MKT0TaI4WPMCc47UINucIXU',
    appId: '1:1036910535170:ios:1f12d9197c6d3898833d1b',
    messagingSenderId: '1036910535170',
    projectId: 'idexapp-9d3de',
    storageBucket: 'idexapp-9d3de.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhmosTs1O1MKT0TaI4WPMCc47UINucIXU',
    appId: '1:1036910535170:ios:1f12d9197c6d3898833d1b',
    messagingSenderId: '1036910535170',
    projectId: 'idexapp-9d3de',
    storageBucket: 'idexapp-9d3de.firebasestorage.app',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB5VZA8jhMSs1q6kuCTNr-ZQ5xk5gtthNU',
    appId: '1:1036910535170:web:b015abf4087adc14833d1b',
    messagingSenderId: '1036910535170',
    projectId: 'idexapp-9d3de',
    authDomain: 'idexapp-9d3de.firebaseapp.com',
    storageBucket: 'idexapp-9d3de.firebasestorage.app',
    measurementId: 'G-3CEV0HEZ7T',
  );
}
