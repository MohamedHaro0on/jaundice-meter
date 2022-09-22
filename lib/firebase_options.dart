// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAwRDSitMNf9daOafTy4YW_WfCC5iEAy_0',
    appId: '1:912627448640:web:a46fab8e5a77d483d4d8a5',
    messagingSenderId: '912627448640',
    projectId: 'jaunidcemeter',
    authDomain: 'jaunidcemeter.firebaseapp.com',
    storageBucket: 'jaunidcemeter.appspot.com',
    measurementId: 'G-B8ZPZXYCXE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjo1phP06DHIU9-psKEH8OiM95TT7DhNM',
    appId: '1:912627448640:android:bcfabd43aa4d3cd0d4d8a5',
    messagingSenderId: '912627448640',
    projectId: 'jaunidcemeter',
    storageBucket: 'jaunidcemeter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_XuT2tPckgzyJWsJzoAp6zkdH0GJzBWw',
    appId: '1:912627448640:ios:12e4ea6684d2627bd4d8a5',
    messagingSenderId: '912627448640',
    projectId: 'jaunidcemeter',
    storageBucket: 'jaunidcemeter.appspot.com',
    iosClientId: '912627448640-7asd35vr8s7nik72q0b3eim16ilr5sp1.apps.googleusercontent.com',
    iosBundleId: 'com.example.firstApp',
  );
}
