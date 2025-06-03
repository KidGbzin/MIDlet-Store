import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../logger.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/progress_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

import '../../services/admob_service.dart';

import '../widgets/loading_widget.dart';

/// A widget that displays a native advertisement using [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) package.
///
/// It manages the advertisement lifecycle and renders different UI states based on the progress of the advertisement loading process.
class AdvertisementWidget extends StatefulWidget {

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;

  const AdvertisementWidget(this.sAdMob, {super.key});

  @override
  State<AdvertisementWidget> createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  late final ValueNotifier<ProgressEnumeration> nProgress;

  late BannerAd advertisement;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing advertisement...");

    nProgress = ValueNotifier(ProgressEnumeration.isLoading);
    advertisement = widget.sAdMob.banner(nProgress);
    advertisement.load();
  }

  @override
  void dispose() {
    Logger.trash("Disposing advertisement...");

    advertisement.dispose();
    nProgress.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: SizedBox(
        height: 250,
        child: ValueListenableBuilder(
          valueListenable: nProgress,
          builder: (BuildContext context, ProgressEnumeration progress, Widget? _) {
            if (progress == ProgressEnumeration.isReady) {
              return AdWidget(
                ad: advertisement,
              );
            }
            else if (progress == ProgressEnumeration.isLoading) {
              return LoadingAnimation();
            }
            else if (progress == ProgressEnumeration.hasError) {
              return Align(
                alignment: Alignment.center,
                child: Icon(
                  HugeIcons.strokeRoundedAdvertisiment,
                  size: 18,
                  color: Palettes.grey.value,
                ),
              );
            }
            else {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  'Unexpected error. Please try again later.',
                  style: TypographyEnumeration.body(Palettes.grey).style,
                ),
              );
            }
          }
        ),
      ),
    );
  }
}