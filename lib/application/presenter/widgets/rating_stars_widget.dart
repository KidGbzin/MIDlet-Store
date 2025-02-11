import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/enumerations/palette_enumeration.dart';

// RATING STARS WIDGET 🧩: ====================================================================================================================================================== //

/// A [Widget] that displays a row of stars to represent a game's rating.
/// 
/// The number of filled stars is determined by the [rating] score, with empty stars filling up the rest.
/// This widget is flexible in size, allowing customization of the star size using [starSize].
class RatingStarsWidget extends StatelessWidget {

  const RatingStarsWidget({
    required this.rating,
    this.starSize = 15,
    super.key,
  });

  /// The game's rating score.
  ///
  /// This score determines the number of filled stars displayed. 
  /// Values are rounded to the nearest whole number for star representation.
  final double rating;

  /// The size of each star in the rating display.
  ///
  /// Defaults to 15.0 if not specified.
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 1.5,
      children: _createRating(),
    );
  }

  /// Generates a list of star widgets based on the [rating] score.
  ///
  /// Filled stars correspond to the rounded value of [rating], while the remaining stars are displayed as empty.
  List<Widget> _createRating() {
    final List<Widget> stars = <Widget> [];

    for (int index = 0; index < 5; index++) {
      if (index < rating.round()) {
        stars.add(_Star.filled(starSize));
      }
      else {
        stars.add(_Star.empty(starSize));
      }
    }
    return stars;
  }
}

// STAR WIDGET 🧩: ============================================================================================================================================================= //

/// A widget representing an individual star, either filled or empty.
///
/// This widget uses predefined icons and colors to indicate whether the star is filled (gold) or empty (grey).
class _Star extends StatelessWidget {

  /// Creates an empty star with a grey outline.
  _Star.empty(this.starSize)
      : color = ColorEnumeration.disabled.value,
        icon = HugeIcons.strokeRoundedStar;

  /// Creates a filled star with a gold color.
  _Star.filled(this.starSize)
      : color = ColorEnumeration.gold.value,
        icon = HugeIcons.strokeRoundedStar;

  /// The color of the star icon.
  final Color color;

  /// The icon representing the star (filled or empty).
  final IconData icon;

  /// The size of the star.
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: starSize,
    );
  }
}