import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdModService {
  static String? getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1079367508189490/4110006139';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1079367508189490/1395207293';
    }

    return null;
  }

  static BannerAdListener listener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint(error.message);
    },
    onAdOpened: (ad) => debugPrint('ad opened'),
    onAdClicked: (ad) => debugPrint('ad closed'),
  );
}