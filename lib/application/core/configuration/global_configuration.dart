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


/// Safely retrieves and validates a typed value from a JSON-like map.
///
/// This function is primarily used to extract a value of type [T] from a `Map<String, dynamic>`, validating its presence and type.
/// It also supports custom deserialization for complex objects through an optional [convert] function.
///
/// Throws:
/// - `FormatException`: Thrown if the key is missing, null (when [nullable] is `false`), has an unexpected type, or if conversion fails.
///
/// Example:
/// ```dart
/// final String name = require<String>(jString, 'name');
///
/// final List<MIDlet> midlets = require<List<MIDlet>>(
///   jString,
///   'midlets',
///   convert: (value) => List<MIDlet>.from((value as List).map(MIDlet.fromJson))
/// );
/// ```
T? require<T>(
  Map<String, dynamic> table,
  String key, {
  bool nullable = false,
  T Function(dynamic)? convert,
}) {
  final dynamic value = table[key];

  if (value == null) {
    if (nullable) return null;

    throw FormatException('Field "$key" is missing or null.');
  }

  // Use custom converter if provided.
  if (convert != null) {
    try {
      return convert(value);
    }
    catch (error) {
      throw FormatException('Field "$key" could not be converted: $error');
    }
  }

  if (T == List<String>) {
    if (value is! List) {
      throw FormatException('Field "$key" expected as List<String>, but received: ${value.runtimeType}');
    }
    try {
      return List<String>.from(value) as T;
    }
    catch (_) {
      throw FormatException('Field "$key" could not be converted to List<String>: $value');
    }
  }

  if (value is! T) {
    throw FormatException('Field "$key" expected as ${T.runtimeType}, but received: ${value.runtimeType}');
  }

  return value;
}