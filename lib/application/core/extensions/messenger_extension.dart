import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../enumerations/palette_enumeration.dart';
import '../enumerations/typographies_enumeration.dart';

/// A custom [SnackBar] extension for displaying event messages to the user.
///
/// The [MessengerExtension] provides a structured and visually consistent way to display notifications.
/// This extension is typically used to provide user feedback, such as confirming a successful action or notifying about an error.
///
/// ### Usage example:
///
/// To display a [MessengerExtension] on the [SnackBar], use the following approach:
/// ```dart
/// ScaffoldMessenger.of(context).showSnackBar(
///   Messenger(
///     message: "Item saved successfully!",
///     icon: Icons.check_circle,
///   ),
/// );
/// ```
class MessengerExtension extends SnackBar {

  /// The icon displayed to the left of the message.
  final IconData icon;
  
  /// The message text displayed in the [SnackBar].
  final String message;

  MessengerExtension({
    required this.message,
    required this.icon,
    super.key,
  }) : super(
    backgroundColor: Palettes.transparent.value,
    elevation: 0,
    padding: EdgeInsets.zero,
    content: Container(
      decoration: BoxDecoration(
        color: Palettes.foreground.value,
      ),
      padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 15,
        children: <Widget> [
          HugeIcon(
            icon: icon,
            color: Palettes.elements.value,
            size: 25,
          ),
          Expanded(
            child: Text(
              message,
              style: TypographyEnumeration.body(Palettes.elements).style,
            ),
          ),
        ],
      ),
    ),
  );
}