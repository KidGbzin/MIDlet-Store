import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../logger.dart';

/// A service class responsible for managing and loading advertisements via AdMob.
///
/// This class utilizes the [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) package to initialize the AdMob SDK and retrieve native advertisements.
/// It automatically determines whether to use test advertisements in debug mode or real production advertisements in release mode.
class AdMobService {

  // MARK: Constructor ⮟
  
  final String bannerUnit;
  final String bannerRectangleUnit;

  AdMobService({
    required this.bannerRectangleUnit,
    required this.bannerUnit,
  });

  final Map<int, BannerAd> _iAdvertisementTable = <int, BannerAd> {};
  final Map<String, BannerAd> _kAdvertisementTable = <String, BannerAd> {};

  Future<void> initialize() async {
    Logger.information("Initializing the AdMob service...");

    await MobileAds.instance.initialize();
  }

  void clear() {
    for (final BannerAd advertisement in _iAdvertisementTable.values) {
      advertisement.dispose();

      Logger.trash("Disposing advertisement...");
    }
    
    for (final BannerAd advertisement in _kAdvertisementTable.values) {
      advertisement.dispose();

      Logger.trash("Disposing advertisement...");
    }

    _iAdvertisementTable.clear();
    _kAdvertisementTable.clear();
  }

  // MARK: Advertisements ⮟

  /// Returns the preloaded [BannerAd] associated with the given [index], if it exists.
  BannerAd? getAdvertisementByIndex(int index) => _iAdvertisementTable[index];

  /// Returns the preloaded [BannerAd] associated with the given [key], if it exists.
  BannerAd? getAdvertisementByKey(String key) => _kAdvertisementTable[key];

  // MARK: Preload by Index ⮟

  /// Preloads banner advertisements for the 2 nearest advertisement slots relative to [iCurrent] index.
  ///
  /// Useful for dynamic lists like `ListView`, where you want to keep only relevant ads in memory.
  void preloadNearbyAdvertisements(int iCurrent, AdSize size) {
    final List<int> indexes = _calculateNearbyIndexes(iCurrent);
    final List<int> indexesToBeRemoved = _iAdvertisementTable.keys.where((key) => !indexes.contains(key)).toList();

    for (final int index in indexesToBeRemoved) {
      _iAdvertisementTable[index]?.dispose();
      _iAdvertisementTable.remove(index);

      Logger.trash("Disposing advertisement with index $index...");
    }

    for (final int index in indexes) {
      if (!_iAdvertisementTable.containsKey(index)) {
        _preloadWithIndex(index, size);
      }
    }
  }

  /// Calculates the list of ad slot indexes closest to the current item index [iCurrent].
  ///
  /// Returns a list with up to 2 advertisement positions:
  /// - The closest previous or current advertisement index (every 6th item),
  /// - The next advertisement slot after that.
  List<int> _calculateNearbyIndexes(int iCurrent) {
    final List<int> indexes = [];
    int? iBase;

    for (int index = iCurrent; index >= 0; index--) {
      if ((index + 1) % 6 == 0) {
        iBase = index;

        break;
      }
    }

    iBase ??= ((iCurrent ~/ 6) + 1) * 6 - 1;
    indexes.add(iBase);

    while (indexes.length < 2) {
      indexes.add(indexes.last + 6);
    }

    return indexes;
  }

  /// Loads and stores a banner ad at the specified [index] if not already loaded.
  ///
  /// Associates the loaded [BannerAd] with its index inside [_iAdvertisementTable].
  /// Automatically disposes the ad and removes it from the table if loading fails.
  void _preloadWithIndex(int index, AdSize size) {
    if (_iAdvertisementTable.containsKey(index)) return;

    _iAdvertisementTable[index] = BannerAd(
      adUnitId: _getAdvertisementUnitBySize(size),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad advertisement) => Logger.information("Advertisement with index $index was sucessfull loaded."),
        onAdFailedToLoad: (Ad advertisement, LoadAdError error) {
          Logger.error("Advertisement with index $index got an error: $error");
          Logger.trash("Disposing advertisement with index $index...");

          advertisement.dispose();
          _iAdvertisementTable.remove(index);
        },
      ),
    )..load();
  }

  // MARK: Preload by Key ⮟

  void preloadAdvertisement(String key, AdSize size) {
    if (_kAdvertisementTable.containsKey(key)) return;

    _kAdvertisementTable[key] = BannerAd(
      adUnitId: _getAdvertisementUnitBySize(size),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad advertisement) => Logger.information("Advertisement with $key was sucessfull loaded."),
        onAdFailedToLoad: (Ad advertisement, LoadAdError error) {
          Logger.error("Advertisement with $key got an error: $error");
          Logger.trash("Disposing advertisement with key $key...");

          advertisement.dispose();
          _kAdvertisementTable.remove(key);
        },
      ),
    )..load();
  }

  // MARK: Helpers ⮟

  /// Returns the appropriate AdMob unit identifier based on the provided [size].
  ///
  /// Throws: 
  /// - `Exception`: Thrown if an unsupported ad size is provided.
  String _getAdvertisementUnitBySize(AdSize size) {
    switch (size) {
      case AdSize.banner: return bannerUnit;
      case AdSize.mediumRectangle: return bannerRectangleUnit;
      default:
        throw Exception("Advertisement size \"$size\" is not supported!");
    }
  }
}