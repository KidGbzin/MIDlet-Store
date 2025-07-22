import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/configuration/global_configuration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

/// A widget that displays a customizable rating slider with labeled feedback.
///
/// The [RatingSliders] allows users to provide a rating between 0 and 5, with visual feedback in the form of an icon and a corresponding descriptive label for each rating level.
/// It supports three types of ratings:
///
/// - `RatingSliders.difficulty`: Measures how difficult the game is.
/// - `RatingSliders.star`: General quality rating, similar to star reviews.
/// - `RatingSliders.playthroughTime`: Estimates the time required to complete the game.
///
/// Each type has its own icon, color theme, and set of descriptive labels.
class RatingSliders extends StatelessWidget {

  final Widget child;

  const RatingSliders._(this.child);

  factory RatingSliders.playthroughTime(int value, void Function(int) onUpdate) {
    return RatingSliders._(
      _PlaythroughTimeSlider(
        hours: value,
        onUpdate: onUpdate,
        labels: <String> [
          "How long does it take to complete?",
          "Less than 1 hour, I barely scratched it!",
          "Around 3 hours, done in one sitting.",
          "Around 5 hours, gave it time, felt complete.",
          "Around 10 hours, took some real effort to finish.",
          "More than 20 hours, an epic journey, completely immersed.",
        ],
      ),
    );
  }

  factory RatingSliders.difficulty(int value, void Function(int) onUpdate) {
    return RatingSliders._(
      _DefaultSlider(
        icon: HugeIcons.strokeRoundedFire,
        color: Colors.orange,
        value: value,
        onUpdate: onUpdate,
        labels: <String> [
          "How difficult is it to play?",
          "Easy peasy! Could play it with my eyes closed.",
          "Had to think a bit, kept me on my toes.",
          "That was tough! Challenging but fair.",
          "Sweating bullets! Intense and demanding.",
          "Unforgiving! No room for mistakes.",
        ],
      ),
    );
  }

  factory RatingSliders.star(int value, void Function(int) onUpdate) {
    return RatingSliders._(
      _DefaultSlider(
        icon: HugeIcons.strokeRoundedStar,
        color: Palettes.gold.value,
        value: value,
        onUpdate: onUpdate,
        labels: <String> [
          "How many stars does it deserve?",
          "Why did I play this? A total regret.",
          "Barely worth the time! Could have been better.",
          "Not bad, not great! Worth a try.",
          "That was awesome! Really enjoyed it.",
          "Masterpiece! One of the best I've played.",
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

/// A widget that displays an animated icon with scaling effect based on its active state.
///
/// This widget is used to visually distinguish between selected (active) and unselected (inactive) icons in the [RatingSliders].
/// When `isActive` is `true`, the icon is slightly scaled up with a highlight color.
/// When `false`, the icon is dimmed and scaled down slightly.
///
/// The animation uses a smooth curve (`Curves.easeOutBack`) for a polished effect.
class _AnimatedIcon extends StatelessWidget {

  /// Whether this icon is active or not.
  ///
  /// Active icons are shown with a scaling animation and the given [color],
  /// while inactive ones appear smaller and use a divider color.
  final bool isActive;

  /// The icon to display.
  final IconData icon;

  /// The color to apply when the icon is active.
  final Color color;

  const _AnimatedIcon({
    required this.color,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: isActive ? 0.75 : 1.0,
        end: isActive ? 1.0 : 0.75,
      ),
      duration: gAnimationDuration,
      curve: Curves.easeOutBack,
      builder: (BuildContext context, double scale, Widget? _) {
        return Transform.scale(
          scale: scale,
          child: Icon(
            icon,
            color: isActive ? color : Palettes.divider.value,
          ),
        );
      },
    );
  }
}

class _DefaultSlider extends StatefulWidget {

  final IconData icon;

  final Color color;

  final int value;

  final void Function(int) onUpdate;

  final List<String> labels;

  const _DefaultSlider({
    required this.icon,
    required this.color,
    required this.value,
    required this.onUpdate,
    required this.labels,
  });

  @override
  State<_DefaultSlider> createState() => _DefaultSliderState();
}

class _DefaultSliderState extends State<_DefaultSlider> {
  late final ValueNotifier<int> nCurrentIndex = ValueNotifier<int>(widget.value);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nCurrentIndex,
      builder: (BuildContext context, int current, Widget? _) {
        return Column(
          spacing: 15,
          children: <Widget> [
            RatingBar(
              updateOnDrag: false,
              initialRating: current.toDouble(),
              itemSize: 40,
              glow: false,
              ratingWidget: RatingWidget(
                full: _AnimatedIcon(
                  icon: widget.icon,
                  isActive: true,
                  color: widget.color,
                ),
                half: const SizedBox.shrink(),
                empty: _AnimatedIcon(
                  icon: widget.icon,
                  isActive: false,
                  color: Palettes.divider.value,
                ),
              ),
              onRatingUpdate: (double value) {
                nCurrentIndex.value = value.toInt();
                widget.onUpdate(value.toInt());
              },
            ),
            Text(
              widget.labels[current],
              style: TypographyEnumeration.body(Palettes.elements).style,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class _PlaythroughTimeSlider extends StatefulWidget {

  final int hours;

  final void Function(int) onUpdate;

  final List<String> labels;

  const _PlaythroughTimeSlider({
    required this.hours,
    required this.onUpdate,
    required this.labels,
  });

  @override
  State<_PlaythroughTimeSlider> createState() => _PlaythroughTimeSliderState();
}

class _PlaythroughTimeSliderState extends State<_PlaythroughTimeSlider> {
  late final ValueNotifier<int> nCurrentIndex = ValueNotifier<int>(toIndex(widget.hours));

  int toIndex(int hours) {
    if (hours == 0) return 0;
    if (hours == 1) return 1;
    if (hours == 3) return 2;
    if (hours == 5) return 3;
    if (hours == 10) return 4;
    if (hours == 20) return 5;
    
    throw RangeError("Hours should be 0, 1, 3, 5, 10 or 20! Received $hours.");
  }

  int toHours(int index) {
    if (index == 0) return 0;
    if (index == 1) return 1;
    if (index == 2) return 3;
    if (index == 3) return 5;
    if (index == 4) return 10;
    if (index == 5) return 20;
    
    throw RangeError("Index should be 0, 1, 2, 3, 4 or 5! Received $index.");
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nCurrentIndex,
      builder: (BuildContext context, int current, Widget? _) {
        return Column(
          spacing: 15,
          children: <Widget> [
            RatingBar(
              updateOnDrag: false,
              initialRating: current.toDouble(),
              itemSize: 40,
              glow: false,
              ratingWidget: RatingWidget(
                full: _AnimatedIcon(
                  icon: HugeIcons.strokeRoundedComingSoon02,
                  isActive: true,
                  color: Colors.lightBlueAccent,
                ),
                half: const SizedBox.shrink(),
                empty: _AnimatedIcon(
                  icon: HugeIcons.strokeRoundedComingSoon02,
                  isActive: false,
                  color: Palettes.divider.value,
                ),
              ),
              onRatingUpdate: (double value) {
                nCurrentIndex.value = value.toInt();
                widget.onUpdate(toHours(value.toInt()));
              },
            ),
            Text(
              widget.labels[current],
              style: TypographyEnumeration.body(Palettes.elements).style,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}