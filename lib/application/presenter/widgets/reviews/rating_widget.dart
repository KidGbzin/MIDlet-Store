import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/core/configuration/global_configuration.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

/// A utility widget for displaying visual rating indicators using icons.
///
/// Use the named constructors to create specific types of rating displays:
/// - [Rating.star]: Shows 0–5 stars for general rating.
/// - [Rating.difficulty]: Shows 1–5 flames for game difficulty.
/// - [Rating.playthroughTime]: Shows an icon and a label for estimated play time.
///
/// All constructors return a standardized widget with consistent spacing and styles.
class Rating extends StatelessWidget {

  /// The widget to be displayed.
  final Widget child;

  const Rating._internal(this.child);

  factory Rating.difficulty(int difficulty) {
    return Rating._internal(
      _IconsList(
        value: difficulty,
        icon: HugeIcons.strokeRoundedFire,
        color: Colors.orange,
      ),
    );
  }

  factory Rating.playthroughTime(int hours) => Rating._internal(_Hours(hours));

  factory Rating.star(int rating) {
    return Rating._internal(
      _IconsList(
        value: rating,
        icon: HugeIcons.strokeRoundedStar,
        color: Palettes.gold.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

/// A widget to display playthrough time as an icon followed by text.
class _Hours extends StatelessWidget {

  /// Index into the [_indexes] list.
  final int value;

  const _Hours(this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        Icon(
          HugeIcons.strokeRoundedComingSoon02,
          color: Colors.lightBlueAccent,
          size: gIconTiny,
        ),
        Text(
          " ${value}h",
          style: TypographyEnumeration.body(Palettes.grey).style,
        ),
      ],
    );
  }
}

/// A reusable widget that renders a sequence of icons (e.g., stars or flames) to represent a rating value.
///
/// The [value] property determines the number of filled icons to show (out of 5).
/// The remaining icons are shown disabled.
class _IconsList extends StatelessWidget {

  /// Number of filled icons to show (out of 5).
  final int value;

  /// Icon to use (e.g., star or flame).
  final IconData icon;

  /// Color of the filled icons.
  final Color color;

  const _IconsList({
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 1.5,
      children: children(),
    );
  }

  /// Generates the list of filled and unfilled icons.
  List<Widget> children() {
    final List<Widget> temporary = <Widget> [];

    for (int index = 0; index < 5; index ++) {
      final bool isFilled = index < value;

      temporary.add(Icon(
        icon,
        color: isFilled ? color : Palettes.divider.value,
        size: gIconTiny,
      ));
    }

    return temporary;
  }
}