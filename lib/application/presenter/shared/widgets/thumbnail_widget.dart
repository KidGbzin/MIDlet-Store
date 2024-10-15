import 'package:flutter/material.dart';

import '../../../core/enumerations/palette_enumeration.dart';

/// Creates a [Widget] that shows an thumbnail image.
class Thumbnail extends StatelessWidget {

  const Thumbnail({
    this.aspectRatio,
    this.border,
    this.borderRadius,
    this.filterQuality,
    required this.image,
    this.onTap,
    super.key,
  });

  final double? aspectRatio;

  final BoxBorder? border;

  /// The border radius of the [Container].
  ///
  /// If this parameter is not specified, a default value of [BorderRadius] is used.
  final BorderRadius? borderRadius;

  /// The quality filter of the image.
  /// 
  /// If this parameter is not specified, defaults to [FilterQuality.none].
  final FilterQuality? filterQuality;

  /// The [ImageProvider] used to display the image.
  ///
  /// This can be any image provider.
  final ImageProvider<Object> image;

  /// The callback function to be called when the widget is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius ?? BorderRadius.circular(15),
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 0.75,
        child: _decoration(),
      ),
    );
  }

  /// Renders an image using a [BoxDecoration].
  ///
  /// This method serves as a workaround for an issue with [Ink] not displaying correctly in certain situations.
  /// Specifically, the issue was observed in the [Search] view when using [Ink] within a [FutureBuilder], where the [Thumbnail] would not render properly.
  /// 
  /// The bug does not occur when using a [Container].
  Widget _decoration() {
    final BoxDecoration decoration = BoxDecoration(
      border: border,
      borderRadius: borderRadius ?? BorderRadius.circular(15),
      boxShadow: kElevationToShadow[3],
      color: Palette.foreground.color,
      image: DecorationImage(
        filterQuality: filterQuality ?? FilterQuality.high,
        fit: BoxFit.contain,
        image: image,
      ),
    );
    if (onTap != null) {
      return Ink(
        decoration: decoration,
      );
    }
    else {
      return Container(
        decoration: decoration,
      );
    }
  }
}