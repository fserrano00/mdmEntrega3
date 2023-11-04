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
    apiKey: 'AIzaSyCk0lOh_O4aovbIlanwLu4IXRtjmg210x0',
    appId: '1:134792027701:web:7e4786ee36003749a01b7c',
    messagingSenderId: '134792027701',
    projectId: 'mdmproyect1',
    authDomain: 'mdmproyect1.firebaseapp.com',
    storageBucket: 'mdmproyect1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOHwXAatQsVdH-VSk8aDaPw76mqb6mNAE',
    appId: '1:134792027701:android:911dd607a9eba34fa01b7c',
    messagingSenderId: '134792027701',
    projectId: 'mdmproyect1',
    storageBucket: 'mdmproyect1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHaIoBKrzrM6FvFNrGGKViBEPkahw0ycM',
    appId: '1:134792027701:ios:eebde4ca7a61d4f2a01b7c',
    messagingSenderId: '134792027701',
    projectId: 'mdmproyect1',
    storageBucket: 'mdmproyect1.appspot.com',
    iosBundleId: 'com.example.proyectomdm',
  );
}
