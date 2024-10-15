import 'package:flutter/material.dart';

/// An enumeration of colors to be used throughout the application. 
/// 
/// Always use the [Palette] class to set a component color. Refer to the architecture document for more information.
enum Palette {

  /// The [Color] used for a [primary] variation, common used on highlighed elements such as tags and filled buttons.
  accent(Color(0xFF7B83C0)),

  /// The [Color] used for scaffolds and backgrounds.
  background(Color(0xff1c1d22)),

  /// The [Color] used for dividers and borders.
  divider(Color(0xff2a2a32)),

  /// The [Color] used for disbled texts or icons.
  disabled(Color(0xFF757575)),

  /// The [Color] used for UI elements such as icons and texts.
  elements(Color(0xffe4e5e9)),

  /// The [Color] used to distinguish foreground elements such as search bars.
  foreground(Color(0xff26262e)),

  /// The [Color] used for rating stars.
  gold(Color(0xFFFAD400)),

  /// The [Color] used for non-highlighted UI elements such as body text and some icons.
  grey(Color(0xFFBDBDBD)),

  /// The [Color] used for detail elements in the UI, such as tag icons.
  primary(Color(0xff50599e)),

  /// A transparent [Color].
  transparent(Color(0x00000000));

  const Palette(this.color);

  /// The [Color] value for a [Palette].
  final Color color;
}