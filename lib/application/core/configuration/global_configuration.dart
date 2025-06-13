import 'package:flutter/material.dart';

import '../enumerations/palette_enumeration.dart';


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
/// This is a divider with a color of [Palettes.divider], a height of 1, and a thickness of 1.
final Divider gDivider = Divider(
  color: Palettes.divider.value,
  height: 1,
  thickness: 1,
);

final Duration gAnimationDuration = Durations.long2;

/// FAB sem padding — canto inferior direito sem considerar padding ou margin
class _GlobalFABLocation extends FloatingActionButtonLocation {

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height;
    
    return Offset(fabX, fabY);
  }
}

/// Getter global para facilitar o uso
final FloatingActionButtonLocation gFABPadding = _GlobalFABLocation();