import 'package:flutter/material.dart';
import 'package:midlet_store/globals.dart';

import '../../core/enumerations/palette_enumeration.dart';

/// A widget that displays a thumbnail image with customizable properties.
///
/// The [ThumbnailWidget] widget is used to render an image with an optional border, border radius, and aspect ratio.
/// It supports tap interactions through the [onTap] callback and provides flexible configuration options for the image's display quality and appearance.
class ThumbnailWidget extends StatelessWidget {

  const ThumbnailWidget({
    this.aspectRatio = 0.75,
    this.border,
    this.filterQuality = FilterQuality.none,
    required this.image,
    this.onTap,
    this.borderRadius,

    super.key,
  });

  /// The aspect ratio of the thumbnail image.
  ///
  /// Determines the width-to-height ratio of the thumbnail.
  /// For example, an aspect ratio of `0.75` indicates that the width is 75% of the height.
  ///
  /// Defaults to `0.75`.
  final double aspectRatio;

  /// The border surrounding the thumbnail.
  ///
  /// If not specified, the widget uses a default border with the color defined by [ColorEnumeration.divider].
  final BoxBorder? border;

  /// The quality filter applied to the thumbnail image.
  ///
  /// Controls the rendering quality of the image.
  /// Higher quality filters, such as [FilterQuality.high], may produce better visuals but might impact performance.
  ///
  /// Defaults to [FilterQuality.none].
  final FilterQuality? filterQuality;

  /// The [ImageProvider] used to display the image.
  ///
  /// This defines the source of the image, which can be any valid image provider, such as [NetworkImage], [AssetImage], or [FileImage].
  final ImageProvider<Object> image;

  /// The callback function triggered when the thumbnail is tapped.
  ///
  /// If this parameter is not provided, the thumbnail will be rendered without interactive behavior.
  final void Function()? onTap;

  /// The border radius applied to the thumbnail's corners.
  ///
  /// Controls the roundness of the thumbnail's edges. If not specified, a default value of [kBorderRadius] is used.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius ?? kBorderRadius,
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: _decoration(),
      ),
    );
  }

  /// Builds the styled container for the thumbnail.
  ///
  /// This method applies a [BoxDecoration] to the image, including the border, border radius, and other styling options.
  /// It uses an [Ink] widget for better compatibility with material design features when [onTap] is specified.
  ///
  /// This method addresses an issue where the [Ink] widget might not render correctly in certain scenarios, such as when placed inside another tappable widget.
  /// By using a [Container] as a fallback, it prevents unintended overlay effects, such as splash animations from the parent widget, ensuring a consistent appearance.
  Widget _decoration() {
    final BoxDecoration decoration = BoxDecoration(
      border: border ?? Border.all(
        color: ColorEnumeration.divider.value,
        width: 1,
      ),
      borderRadius: borderRadius ?? kBorderRadius,
      color: ColorEnumeration.foreground.value,
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