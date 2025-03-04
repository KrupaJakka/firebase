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
    apiKey: 'AIzaSyDMCvLWp4gprUoihtqeqv661ajxmo26qE8',
    appId: '1:204596305633:web:c0d4f040e916441d6ca1a0',
    messagingSenderId: '204596305633',
    projectId: 'fir-cda0f',
    authDomain: 'fir-cda0f.firebaseapp.com',
    storageBucket: 'fir-cda0f.firebasestorage.app',
    measurementId: 'G-9BH0BHRFYZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBU1X-clhpTi-A-Kqx6wyDW5vv39BA0xwM',
    appId: '1:204596305633:android:9fbf40079f2b8e736ca1a0',
    messagingSenderId: '204596305633',
    projectId: 'fir-cda0f',
    storageBucket: 'fir-cda0f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTBCFZtuvuDxbQnS6kRK4UlgaA4v2NcME',
    appId: '1:204596305633:ios:79ad1c3e5ecee9a66ca1a0',
    messagingSenderId: '204596305633',
    projectId: 'fir-cda0f',
    storageBucket: 'fir-cda0f.firebasestorage.app',
    iosClientId: '204596305633-18g3vmu35fp628qf4erjfd1gfeu63vc6.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTBCFZtuvuDxbQnS6kRK4UlgaA4v2NcME',
    appId: '1:204596305633:ios:79ad1c3e5ecee9a66ca1a0',
    messagingSenderId: '204596305633',
    projectId: 'fir-cda0f',
    storageBucket: 'fir-cda0f.firebasestorage.app',
    iosClientId: '204596305633-18g3vmu35fp628qf4erjfd1gfeu63vc6.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDMCvLWp4gprUoihtqeqv661ajxmo26qE8',
    appId: '1:204596305633:web:fa6ccae6aef230f46ca1a0',
    messagingSenderId: '204596305633',
    projectId: 'fir-cda0f',
    authDomain: 'fir-cda0f.firebaseapp.com',
    storageBucket: 'fir-cda0f.firebasestorage.app',
    measurementId: 'G-Y0NTCJBT6C',
  );
}
