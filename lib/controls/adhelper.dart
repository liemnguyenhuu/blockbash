/*import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  /// Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (kDebugMode) {
      // Test IDs của Google
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // Android Test Banner
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // iOS Test Banner
      }
    }

    // Release Ad Unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-6739606842301630/9056094520'; // Android Banner thật
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6739606842301630/6780835268'; // iOS Banner thật
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712'; // Android Test Interstitial
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910'; // iOS Test Interstitial
      }
    }

    if (Platform.isAndroid) {
      return 'ca-app-pub-6739606842301630/1173735075'; // Android Interstitial thật
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6739606842301630/8651609696'; // iOS Interstitial thật
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917'; // Android Test Rewarded
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313'; // iOS Test Rewarded
      }
    }

    if (Platform.isAndroid) {
      return 'ca-app-pub-6739606842301630/5382581000'; // Android Rewarded thật
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6739606842301630/8084633487'; // iOS Rewarded thật
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
*/

