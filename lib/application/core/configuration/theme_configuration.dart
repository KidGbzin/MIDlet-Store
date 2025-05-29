import 'package:flutter/material.dart';

import '../enumerations/palette_enumeration.dart';

// THEME CONFIGURATION ⚙️: ============================================================================================================================================================ //

/// The application's theme.
///
/// This theme is applied to the root widget of the application.
/// It's used to configure the colors, typography, and other design elements of the application.
final ThemeData theme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Palettes.background.value,
    toolbarHeight: 70,
    titleSpacing: 15,
    shape: Border(
      bottom: BorderSide(
        color: Palettes.divider.value,
        width: 1,
      ),
    ),
    surfaceTintColor: Palettes.background.value,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Palettes.background.value,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    surfaceTintColor: Palettes.background.value,
  ),
  highlightColor: Palettes.elements.value.withAlpha(25),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder> {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: Palettes.background.value,
  splashColor: Palettes.splash.value,
);