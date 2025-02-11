import 'dart:ui';

import '../enumerations/logger_enumeration.dart';

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

  /// English locale.
  english(
    iconPath: 'assets/flags/US.gif',
    label: 'ENGLISH',
    locale: Locale('en', 'US'),
  );

  /// The path to the flag icon for the locale.
  final String iconPath;

  /// A human-readable label for the locale.
  final String label;

  /// The [Locale] object representing the locale.
  final Locale locale;

  /// Creates a new [L10nEnumeration] with the given properties.
  const L10nEnumeration({
    required this.iconPath,
    required this.locale,
    required this.label,
    
  });

  /// Returns the [L10nEnumeration] corresponding to the given language code.
  ///
  /// If the language code is not recognized, it returns the [english] locale by default.
  static L10nEnumeration fromCode(String code) {
    final Map<String, L10nEnumeration> table = <String, L10nEnumeration> {
      'BR': L10nEnumeration.brazilianPortuguese,
      'US': L10nEnumeration.english,
    };

    final L10nEnumeration? locale = table[code];

    if (locale != null) return locale;

    Logger.error.print(
      message: 'Locale "$code" not found, defaulting to "US" locale.',
      label: 'L10n Enumeration | From Code',
    );

    return L10nEnumeration.english;
  }
}
