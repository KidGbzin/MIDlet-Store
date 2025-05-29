import 'package:flutter/material.dart';

import '../../core/configuration/global_configuration.dart';

import '../../core/enumerations/palette_enumeration.dart';

/// A button widget that can be used to create different types of buttons.
///
/// The [ButtonWidget] widget is a wrapper around the [InkWell] widget and provides some default styling and behaviors for creating buttons.
class ButtonWidget extends StatelessWidget {

  const ButtonWidget._({
    required this.onTap,
    required this.child,
  });

  /// Creates a button with an icon as its child.
  ///
  /// The `icon` parameter is required and specifies the icon to display as the button's child. \
  /// The `iconColor` parameter is optional and specifies the color of the icon. If not specified, the icon color will default to [Palettes.elements]. \
  /// The `onTap` parameter is also required and specifies the callback function to call when the button is tapped.
  factory ButtonWidget.icon({
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ButtonWidget._(
      onTap: onTap,
      child: InkWell(
        borderRadius: gBorderRadius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: Palettes.transparent.value,
          ),
          height: 40,
          width: 40,
          child: Icon(
            icon,
            color: iconColor ?? Palettes.elements.value,
            size: 25,
          ),
        ),
      )
    );
  }

  /// Creates a button with a custom widget as its child.
  ///
  /// The `child` parameter is required and specifies the custom widget to use as the button's child.
  /// The `color` parameter is optional and specifies the background color of the button. If not specified, the button color will default to [Palettes.primary]. \
  /// The `onTap` parameter is required and specifies the callback function to call when the button is tapped. \
  /// The `splashColor` parameter is optional and specifies the color of the splash effect when the button is tapped.
  /// If not specified, the splash color will default to [Palettes.primary]. \
  /// The `width` parameter is optional and specifies the width of the button. If not specified, the button will take up the full width of its parent. \  
  factory ButtonWidget.widget({
    required Widget child,
    Color? color,
    required VoidCallback onTap,
    Color? splashColor,
    double? width,
  }) {
    return ButtonWidget._(
      onTap: onTap,
      child: InkWell(
        borderRadius: gBorderRadius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: color ?? Palettes.primary.value,
          ),
          height: 45,
          width: width,
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      )
    );
  }

  /// The callback function to call when the button is tapped.
  final VoidCallback onTap;

  /// The child widget displayed inside the button.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
