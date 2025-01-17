// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCepmtzFBsl3qKvWNq4P5JN-IluyFH7yV8',
    appId: '1:558528641925:web:9282d8e0477a4c0b98e2ec',
    messagingSenderId: '558528641925',
    projectId: 'cardworld-2bdca',
    authDomain: 'cardworld-2bdca.firebaseapp.com',
    storageBucket: 'cardworld-2bdca.firebasestorage.app',
    measurementId: 'G-D2HF7DEMGQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIb4xB871AlAt9Rsv389wmdKteQBtAKnw',
    appId: '1:558528641925:android:a581236cfde2f8f798e2ec',
    messagingSenderId: '558528641925',
    projectId: 'cardworld-2bdca',
    storageBucket: 'cardworld-2bdca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu9xxmoNQLhsoDpZB5xuscVHYMkLsS05I',
    appId: '1:558528641925:ios:babe015123bc9e5398e2ec',
    messagingSenderId: '558528641925',
    projectId: 'cardworld-2bdca',
    storageBucket: 'cardworld-2bdca.firebasestorage.app',
    iosBundleId: 'com.example.cardworld',
  );
}
