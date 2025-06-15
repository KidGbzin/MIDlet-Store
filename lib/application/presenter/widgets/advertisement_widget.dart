import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Advertisement extends StatelessWidget {
  
  final BannerAd? advertisement;

  const Advertisement.banner(this.advertisement, {super.key});

  @override
  Widget build(BuildContext context) {
    if (advertisement == null) return SizedBox.shrink();
    if (advertisement!.responseInfo == null) return SizedBox.shrink();

    return Container(
      height: advertisement!.size.height.toDouble(),
      margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
      width: advertisement!.size.width.toDouble(),
      child: AdWidget(
        ad: advertisement!,
      ),
    );
  }
}