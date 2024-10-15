import 'package:flutter/material.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

/// Create a section of a given collection.
/// 
/// A section is used to show a category of games.
class Section extends StatelessWidget {

  const Section({
    this.child,
    required this.description,
    required this.title,
    super.key,
  });

  /// The title of the section.
  ///
  /// This should be a unique, interesting, and appealing title that captures the essence of the category.
  final String title;

  /// A brief description of the category.
  ///
  /// This provides more context about the category and what kind of games it includes.
  final String description;

  /// The body widget of the section.
  /// 
  /// If this parameter is not specified, a [SizedBox.shrink] is used.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Typographies.headline(Palette.elements).style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              description,
              style: Typographies.body(Palette.grey).style,
            ),
          ),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}