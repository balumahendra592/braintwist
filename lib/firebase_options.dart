// Generated from google-services.json (android only — iOS not configured)
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuRtr6YS5oh9xDioREpzjTjaLPrHU641s',
    appId: '1:822857102811:android:cf747cd974a85f169123fe',
    messagingSenderId: '822857102811',
    projectId: 'braintwist-6917e',
    storageBucket: 'braintwist-6917e.firebasestorage.app',
  );
}
