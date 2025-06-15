import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../logger.dart';

import '../core/enumerations/views_enumerations.dart';

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

  Future<void> initialize() async {
    Logger.information("Initializing the AdMob service...");

    await MobileAds.instance.initialize();
  }

  void clear(Views view) {
    Logger.trash("Disposing ${view.name} view advertisements...");

    final Map<dynamic, BannerAd> table = _getTable(view);

    for (final BannerAd advertisements in table.values) {
      advertisements.dispose();
    }
    table.clear();
  }

  final Map<int, BannerAd> _searchAdvertisementsTable = <int, BannerAd> {};
  final Map<int, BannerAd> _reviewsAdvertisementsTable = <int, BannerAd> {};
  final Map<int, BannerAd> _midletsAdvertisementsTable = <int, BannerAd> {};

  final Map<String, BannerAd> _installationAdvertisementsTable = <String, BannerAd> {};

  // MARK: By Index ⮟

  /// Returns the preloaded [BannerAd] associated with the given [index], if it exists.
  BannerAd? getAdvertisementByIndex(int index, Views view) => _getTable(view)[index];

  /// Preloads banner advertisements for the 2 nearest advertisement slots relative to [iCurrent] index.
  ///
  /// Useful for dynamic lists like `ListView`, where you want to keep only relevant ads in memory.
  void preloadNearbyAdvertisements({
    required int iCurrent,
    required AdSize size,
    required Views view,
  }) {
    final Map<int, BannerAd> table = _getTable(view) as Map<int, BannerAd>;

    final List<int> indexes = _calculateNearbyIndexes(iCurrent);
    final List<int> indexesToBeRemoved = table.keys.where((key) => !indexes.contains(key)).toList();

    for (final int index in indexesToBeRemoved) {
      table[index]?.dispose();
      table.remove(index);

      Logger.trash("Disposing advertisement with index $index...");
    }

    for (final int index in indexes) {
      if (!table.containsKey(index)) {
        _preloadWithIndex(
          index: index,
          size: size,
          table: table,
        );
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
  /// Associates the loaded [BannerAd] with its index inside [_searchAdvertisementsTable].
  /// Automatically disposes the ad and removes it from the table if loading fails.
  void _preloadWithIndex({
    required int index,
    required AdSize size,
    required Map<int, BannerAd> table,
  }) {
    if (table.containsKey(index)) return;

    table[index] = BannerAd(
      adUnitId: _getAdvertisementUnitBySize(size),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad advertisement) => Logger.information("Advertisement with index $index was sucessfull loaded."),
        onAdFailedToLoad: (Ad advertisement, LoadAdError error) {
          Logger.error("Advertisement with index $index got an error: $error");
          Logger.trash("Disposing advertisement with index $index...");

          advertisement.dispose();
          table.remove(index);
        },
      ),
    )..load();
  }

  // MARK: Manually ⮟

  Future<BannerAd> preloadAdvertisement(String key, AdSize size) {
    final Completer<BannerAd> completer = Completer<BannerAd>();

    late final BannerAd ad;

    ad = BannerAd(
      adUnitId: _getAdvertisementUnitBySize(size),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          Logger.information("Advertisement with key $key was successfully loaded.");
          completer.complete(ad);
        },
        onAdFailedToLoad: (Ad advertisement, LoadAdError error) {
          Logger.error("Advertisement with key $key got an error: $error");
          Logger.trash("Disposing advertisement with key $key...");

          advertisement.dispose();
          completer.completeError(error);
        },
      ),
    );

    ad.load();
    return completer.future;
  }

  Future<Map<String, BannerAd?>> getMultipleAdvertisements(List<String> keys, AdSize size) async {
    final Map<String, BannerAd?> table = <String, BannerAd?> {};
    
    final Iterable<Future<Null>> futures = keys.map((key) async {
      try {
        final BannerAd advertisement = await preloadAdvertisement(key, size);
        table[key] = advertisement;
      }
      catch (_) {
        table[key] = null;
      }
    });

    await Future.wait(futures);

    return table;
  }

  // MARK: Helpers ⮟

  Map<dynamic, BannerAd> _getTable(Views view) {
    switch (view) {
      case (Views.installation): return _installationAdvertisementsTable;
      case (Views.midlets): return _midletsAdvertisementsTable;
      case (Views.reviews): return _reviewsAdvertisementsTable;
      case (Views.search): return _searchAdvertisementsTable;
      default: throw Exception();
    }
  }

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