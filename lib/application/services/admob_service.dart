import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../logger.dart';

import '../core/enumerations/progress_enumeration.dart';

/// A service class responsible for managing and loading advertisements via AdMob.
///
/// This class utilizes the [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) package to initialize the AdMob SDK and retrieve native advertisements.
/// It automatically determines whether to use test advertisements in debug mode or real production advertisements in release mode.
class AdMobService {

  AdMobService(this.releaseAdUnitId);

  // Ad unit ID used for real advertisements in the release environment.
  final String releaseAdUnitId;

  // Test ad unit ID used during development.
  // For more test IDs, visit: (https://developers.google.com/admob/android/test-ads).
  final String debugAdUnitId = "ca-app-pub-3940256099942544/2247696110";

  // Holds the currently active ad unit ID, determined based on the app's build mode (debug or release).
  late final String adUnitId;

  /// Initializes the AdMob service by setting up the SDK and selecting the appropriate ad unit ID based on the build mode.
  ///
  /// This method performs the following steps:
  /// - Logs the initialization process with context-specific messages.
  /// - Uses the test advertisement unit ID `debugAdUnitId` in debug mode.
  /// - In release mode:
  ///   - If a valid `releaseAdUnitId` is provided, it is used.
  ///   - If `releaseAdUnitId` is empty, it falls back to the test advertisement unit ID.
  ///
  /// After determining the advertisement unit ID, it initializes the AdMob SDK via [MobileAds.instance.initialize].
  Future<void> initialize() async {
    String body = "Initializing the AdMob service";

    if (kDebugMode) {
      body += " as debug...";
      adUnitId = debugAdUnitId;
    }
    
    if (kReleaseMode) {
      if (releaseAdUnitId.isEmpty) {
        body += " as debug since no release advertisement token was given...";
        adUnitId = debugAdUnitId;
      }
      else {
        body += " as release...";
        adUnitId = releaseAdUnitId;
      }
    }

    Logger.information(body);

    await MobileAds.instance.initialize();
  }

  /// Retrieves a [NativeAd] instance and manages its loading state.
  /// 
  /// The [nProgress] notifier is used to track the ad's loading progress:
  /// - `ProgressEnumeration.loading` when the ad is loading.
  /// - `ProgressEnumeration.ready` when the ad is loaded and ready to be displayed.
  /// - `ProgressEnumeration.error` if the ad fails to load.
  ///
  /// The method returns a [NativeAd] object configured with the appropriate ad unit ID, ad request, and a listener to handle ad loading events.
  NativeAd getAdvertisement(ValueNotifier<ProgressEnumeration> nProgress) {
    return NativeAd(
      adUnitId: adUnitId,
      factoryId: 'Native Advertisement',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          Logger.information("Advertisement is ready!");
          nProgress.value = ProgressEnumeration.isReady;
        },
        onAdFailedToLoad: (advertisement, error) {
          Logger.error("$error");
          nProgress.value = ProgressEnumeration.hasError;
          advertisement.dispose();
        },
      ),
    );
  }
}