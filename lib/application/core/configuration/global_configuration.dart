import 'package:flutter/material.dart';

import '../enumerations/palette_enumeration.dart';

// GLOBAL CONFIGURATION ⚙️: ===================================================================================================================================================== //

/// The default [BorderRadius] used in the application.
/// 
/// This is a circular border with a radius of 10.
final BorderRadius gBorderRadius = BorderRadius.circular(10);

/// The default [BorderRadius] used in the application as double.
/// 
/// Has a value of 10.
final int gRadius = 10;

/// The default [Divider] used in the application.
/// 
/// This is a divider with a color of [ColorEnumeration.divider], a height of 1, and a thickness of 1.
final Divider gDivider = Divider(
  color: ColorEnumeration.divider.value,
  height: 1,
  thickness: 1,
);