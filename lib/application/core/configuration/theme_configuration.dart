import 'package:flutter/material.dart';

import '../enumerations/palette_enumeration.dart';

// THEME CONFIGURATION ⚙️: ============================================================================================================================================================ //

/// The application's theme.
///
/// This theme is applied to the root widget of the application.
/// It's used to configure the colors, typography, and other design elements of the application.
final ThemeData theme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: ColorEnumeration.background.value,
    toolbarHeight: 70,
    titleSpacing: 15,
    shape: Border(
      bottom: BorderSide(
        color: ColorEnumeration.divider.value,
        width: 1,
      ),
    ),
    surfaceTintColor: ColorEnumeration.background.value,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: ColorEnumeration.background.value,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    surfaceTintColor: ColorEnumeration.background.value,
  ),
  highlightColor: ColorEnumeration.elements.value.withAlpha(25),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder> {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: ColorEnumeration.background.value,
  splashColor: ColorEnumeration.splash.value,
);