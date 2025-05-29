import 'package:flutter/material.dart';

import '../../core/configuration/global_configuration.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

/// A customizable animated gradient button with an icon and text.
/// 
/// The gradient smoothly transitions between primary and accent colors over time.
class GradientButton extends StatefulWidget {

  /// Icon to display alongside the text.
  final IconData icon;

  /// Callback function triggered when the button is tapped.
  final Function() onTap;

  /// Text to display inside the button.
  final String text;

  /// Width of the button.
  /// If not specified, defaults to [double.infinity] in layout.
  final double width;

  final Palettes primaryColor;

  final Palettes secondaryColor;

  const GradientButton({
    required this.icon,
    required this.onTap,
    required this.text,
    this.primaryColor = Palettes.primary,
    this.secondaryColor = Palettes.accent,
    this.width = double.infinity,
    super.key,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  late final List<ColorTween> tweens;

  late final List<Color> primary = <Color> [
    widget.primaryColor.value,
    widget.secondaryColor.value,
  ];

  late final List<Color> secondary = <Color> [
    widget.secondaryColor.value,
    widget.primaryColor.value,
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );
    controller.repeat(
      reverse: true,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    tweens = List.generate(
      primary.length,
      (int index) => ColorTween(
        begin: primary[index],
        end: secondary[index],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () => widget.onTap(),
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? _) {
          return Ink(
            height: 45,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: gBorderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: tweens.map((tween) => tween.evaluate(animation)!).toList(),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 7.5,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TypographyEnumeration.headline(Palettes.elements).style,
                  ),
                ),
                Icon(
                  widget.icon,
                  size: 25,
                  color: Palettes.elements.value,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}