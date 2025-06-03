import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../logger.dart';

import '../core/enumerations/progress_enumeration.dart';

/// A service class responsible for managing and loading advertisements via AdMob.
///
/// This class utilizes the [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) package to initialize the AdMob SDK and retrieve native advertisements.
/// It automatically determines whether to use test advertisements in debug mode or real production advertisements in release mode.
class AdMobService {

  final String bannerUnit;

  AdMobService(this.bannerUnit);

  Future<void> initialize() async {
    String body = "Initializing the AdMob service...";

    Logger.information(body);

    await MobileAds.instance.initialize();
  }

  BannerAd banner(ValueNotifier<ProgressEnumeration> nProgress) {
    return BannerAd(
      adUnitId: bannerUnit,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          Logger.information("Banner Ad loaded successfully!");

          nProgress.value = ProgressEnumeration.isReady;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Logger.error("Banner Ad failed to load: $error");

          nProgress.value = ProgressEnumeration.hasError;
          ad.dispose();
        },
      ),
    );
  }
}