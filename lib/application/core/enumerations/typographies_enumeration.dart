import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette_enumeration.dart';

/// A kind of enumeration of text styles to be used on the application. \
/// Always use the [Typographies] class to set a typography. Check the architecture document for more information.
/// 
/// The parameter [style] is the style design of the text. It's of type [TextStyle].
class Typographies {
  final TextStyle style;

  const Typographies._internal(this.style);

  factory Typographies.body(Palette palette) {
    return Typographies._internal(GoogleFonts.rajdhani(
      color: palette.color,
      fontSize: 13.5,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ));
  }

  factory Typographies.tags(Palette palette) {
    return Typographies._internal(GoogleFonts.rajdhani(
      color: palette.color,
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
    ));
  }

  factory Typographies.numbers(Palette palette) {
    return Typographies._internal(GoogleFonts.lekton(
      color: palette.color,
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
    ));
  }

  factory Typographies.headline(Palette palette) {
    return Typographies._internal(GoogleFonts.rajdhani(
      color: palette.color,
      fontSize: 15.5,
      fontWeight: FontWeight.w600,
      height: 1,
      letterSpacing: 1.25,
    ));
  }

  factory Typographies.button(Palette palette) {
    return Typographies._internal(GoogleFonts.rajdhani(
      color: palette.color,
      fontSize: 15.5,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: 1.25,
    ));
  }
}