import 'package:flutter/material.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

/// A widget that creates a section displaying a category of games.
/// 
/// A section typically includes a title, a brief description, and an optional body (such as a list of games).
/// The title should be unique and attention-grabbing to reflect the essence of the game category.
class Section extends StatelessWidget {

  const Section({
    this.child,
    required this.description,
    required this.title,
    super.key,
  });

  /// The title of the section.
  /// 
  /// This title represents the category or theme of the games in this section. 
  /// It should be interesting and clear to give users a sense of what the category is about.
  final String title;

  /// A brief description of the category.
  /// 
  /// This provides additional context or details about the games included in this section.
  final String description;

  /// The body widget of the section.
  /// 
  /// This widget could display the actual games or other related content. 
  /// If not provided, a [SizedBox.shrink] is used, ensuring the section remains empty.
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
            padding: const EdgeInsets.fromLTRB(15 - 1, 0, 15, 15), // The headline font is misaligned by a single pixel.
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              description,
              style: TypographyEnumeration.body(ColorEnumeration.grey).style,
            ),
          ),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}