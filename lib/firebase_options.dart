import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _placeholder = 'REPLACE_WITH_YOUR_VALUE';

class DefaultFirebaseOptions {
  /// Safely get environment variable value, returns placeholder if not found
  static String _getEnvValue(String key) {
    try {
      return dotenv.env[key] ?? _placeholder;
    } catch (e) {
      // dotenv not initialized, return placeholder
      return _placeholder;
    }
  }
  static bool get isConfigured {
    final options = _platformOptionsOrNull();
    if (options == null) {
      return false;
    }
    return options.apiKey != _placeholder &&
        options.appId != _placeholder &&
        options.projectId != _placeholder &&
        options.messagingSenderId != _placeholder;
  }

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
      case TargetPlatform.linux:
        return desktop;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions? _platformOptionsOrNull() {
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
      case TargetPlatform.linux:
        return desktop;
      default:
        return null;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _getEnvValue('FIREBASE_ANDROID_API_KEY'),
    appId: _getEnvValue('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: _getEnvValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _getEnvValue('FIREBASE_PROJECT_ID'),
    storageBucket: _getEnvValue('FIREBASE_STORAGE_BUCKET'),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _getEnvValue('FIREBASE_IOS_API_KEY'),
    appId: _getEnvValue('FIREBASE_IOS_APP_ID'),
    messagingSenderId: _getEnvValue('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: _getEnvValue('FIREBASE_PROJECT_ID'),
    storageBucket: _getEnvValue('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: _getEnvValue('FIREBASE_IOS_BUNDLE_ID'),
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    iosBundleId: _placeholder,
    storageBucket: _placeholder,
  );

  static const FirebaseOptions desktop = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
  );
}
