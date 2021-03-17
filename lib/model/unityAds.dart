import 'dart:io';

class AdManager {
  static String get gameId {
    if (Platform.isAndroid) {
      return '3964095';
    }
    if (Platform.isIOS) {
      return '3964094';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdPlacementId {
    return 'banner';
  }

  static String get interstitialVideoAdPlacementId {
    return 'interstitial';
  }

  static String get rewardedVideoAdPlacementId {
    return 'rewardedVideo';
  }
}