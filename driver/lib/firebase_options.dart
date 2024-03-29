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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCnZh8CYGwhqHIBed6JmG_Yo91cZFPjjbc',
    appId: '1:175776650818:web:1ad9b265e4e0c2dcf4ffdb',
    messagingSenderId: '175776650818',
    projectId: 'eyyautobooking',
    authDomain: 'eyyautobooking.firebaseapp.com',
    databaseURL: 'https://eyyautobooking-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'eyyautobooking.appspot.com',
    measurementId: 'G-3E6NYB4CT9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9lDUV9fcEo1Y8049n9t-hUj3fXeAGDNs',
    appId: '1:175776650818:android:44cdde84471558a9f4ffdb',
    messagingSenderId: '175776650818',
    projectId: 'eyyautobooking',
    databaseURL: 'https://eyyautobooking-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'eyyautobooking.appspot.com',
  );
}
