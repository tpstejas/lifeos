// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3VreDwSlPserNTpD_1n0JDTzdCLAohFk',
    appId: '1:483104489761:android:4d0d22a5ff4e006c107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8g993q7PMc3kxFmzxQnbeuHGViwTFODw',
    appId: '1:483104489761:ios:43af0264346f190b107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
    iosBundleId: 'com.example.lifeos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8g993q7PMc3kxFmzxQnbeuHGViwTFODw',
    appId: '1:483104489761:ios:43af0264346f190b107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
    iosBundleId: 'com.example.lifeos',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3VreDwSlPserNTpD_1n0JDTzdCLAohFk',
    appId: '1:483104489761:android:4d0d22a5ff4e006c107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyB3VreDwSlPserNTpD_1n0JDTzdCLAohFk',
    appId: '1:483104489761:android:4d0d22a5ff4e006c107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5Nk998C2pTkNXU0toLZl7RCfY-fj4Ezs',
    appId: '1:483104489761:web:c06d44eeec791baf107e60',
    messagingSenderId: '483104489761',
    projectId: 'lifeos-2c8c7',
    authDomain: 'lifeos-2c8c7.firebaseapp.com',
    storageBucket: 'lifeos-2c8c7.firebasestorage.app',
    measurementId: 'G-MX4HPPTG7P',
  );
}