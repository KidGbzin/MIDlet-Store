import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette_enumeration.dart';

/// A kind of enumeration of text styles to be used on the application. \
/// Always use the [TypographyEnumeration] class to set a typography. Check the architecture document for more information.
/// 
/// The parameter [style] is the style design of the text. It's of type [TextStyle].
class TypographyEnumeration {

  const TypographyEnumeration._internal(this.style);

  final TextStyle style;

  factory TypographyEnumeration.body(ColorEnumeration palette) {
    return TypographyEnumeration._internal(GoogleFonts.rajdhani(
      color: palette.value,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ));
  }

  factory TypographyEnumeration.theme(ColorEnumeration palette) {
    return TypographyEnumeration._internal(GoogleFonts.rajdhani(
      color: palette.value,
      fontSize: 45,
      fontWeight: FontWeight.w600,
      height: 1,
      wordSpacing: 1.25,
    ));
  }

  factory TypographyEnumeration.rating(ColorEnumeration palette) {
    return TypographyEnumeration._internal(GoogleFonts.rajdhani(
      color: palette.value,
      fontSize: 35,
      fontWeight: FontWeight.w500,
      height: 1
    ));
  }

  factory TypographyEnumeration.headline(ColorEnumeration palette) {
    return TypographyEnumeration._internal(GoogleFonts.rajdhani(
      color: palette.value,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1,
      letterSpacing: 1.25,
    ));
  }
}