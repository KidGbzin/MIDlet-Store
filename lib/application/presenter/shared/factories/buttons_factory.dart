import 'package:flutter/material.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

part '../factories/buttons/default_button.dart';
part '../factories/buttons/named_button.dart';

/// A factory for creating [Widget] buttons.
class Button extends StatelessWidget {

  const Button._({
    required this.child,
    required this.rippleColor,
    required this.onTap,
  });

  /// The color of the ripple effect for the [InkWell].
  ///
  /// If this parameter is not specified, the ripple effect color defaults to the current theme's [ThemeData.splashColor] and [ThemeData.highlightColor].
  final Color? rippleColor;

  /// The widget representing the button's appearance.
  final Widget child;

  /// Callback function to be called when the button is tapped.
  final void Function() onTap;

  /// Creates a square [Button].
  factory Button({
    required IconData icon,
    required void Function() onTap,
  }) {
    return Button._(
      rippleColor: Palette.divider.color,
      onTap: onTap,
      child: _Button(
        icon: icon,
      ),
    );
  }

  /// Creates a [Button] with a leading text.
  factory Button.withTitle({
    required IconData icon,
    required void Function() onTap,
    required String title,
    double? width,
    bool filled = false,
  }) {
    return Button._(
      rippleColor: filled ? Palette.primary.color.withOpacity(0.15) : null,
      onTap: onTap,
      child: _NamedButton(
        filled: filled,
        icon: icon,
        title: title,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      highlightColor: rippleColor,
      onTap: onTap,
      splashColor: rippleColor,
      child: child,
    );
  }
}