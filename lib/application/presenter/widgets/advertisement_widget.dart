import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/enumerations/logger_enumeration.dart';
import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/progress_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

import '../widgets/loading_widget.dart';

/// A widget that displays a native advertisement using [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) package.
///
/// It manages the advertisement lifecycle and renders different UI states based on the progress of the advertisement loading process.
class AdvertisementWidget extends StatefulWidget {

  const AdvertisementWidget({
    required this.getAdvertisement,
    super.key,
  });

  /// Callback that provides a [NativeAd] and receives a [ValueNotifier] to monitor the advertisement's loading state, such as loading, ready, or error.
  final NativeAd Function(ValueNotifier<ProgressEnumeration> nProgress) getAdvertisement;

  @override
  State<AdvertisementWidget> createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  late final ValueNotifier<ProgressEnumeration> nProgress;
  late NativeAd advertisement;

  @override
  void initState() {
    nProgress = ValueNotifier(ProgressEnumeration.loading);
    advertisement = widget.getAdvertisement(nProgress);
    advertisement.load();

    super.initState();
  }

  @override
  void dispose() {
    Logger.information.log("Disposing advertisement...");

    advertisement.dispose();
    nProgress.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 242.5 + 50, // Extra padding is included directly in the height to prevent layout issues with the advertisement.
      child: ValueListenableBuilder(
        valueListenable: nProgress,
        builder: (BuildContext context, ProgressEnumeration progress, Widget? _) {
          if (progress == ProgressEnumeration.ready) {
            return AdWidget(
              ad: advertisement,
            );
          }
          else if (progress == ProgressEnumeration.loading) {
            return LoadingAnimation();
          }
          else if (progress == ProgressEnumeration.error) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                'Unable to load advertisement at the moment.', // TODO: Implement translation for this message.
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            );
          }
          else {
            return Align(
              alignment: Alignment.center,
              child: Text(
                'Unexpected error. Please try again later.', // TODO: Implement translation for this message.
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            );
          }
        }
      ),
    );
  }
}