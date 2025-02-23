import 'dart:ui';

/// An enumeration of supported locales in the application.
///
/// Each locale is represented by its language code and country code.
enum L10nEnumeration {

  /// Brazilian Portuguese locale.
  brazilianPortuguese(
    iconPath: 'assets/flags/BR.gif',
    label: 'PORTUGUÊS BRASILEIRO',
    locale: Locale('pt','BR'),
  ),

  bahasaIndonesia(
    iconPath: 'assets/flags/ID.gif',
    label: 'BAHASA IMDONESIA',
    locale: Locale('id', 'ID'),
  ),

  /// English locale.
  english(
    iconPath: 'assets/flags/US.gif',
    label: 'ENGLISH',
    locale: Locale('en', 'US'),
  );

  const L10nEnumeration({
    required this.iconPath,
    required this.locale,
    required this.label,   
  });

  /// The path to the flag icon for the locale.
  final String iconPath;

  /// A human-readable label for the locale.
  final String label;

  /// The [Locale] object representing the locale.
  final Locale locale;
}