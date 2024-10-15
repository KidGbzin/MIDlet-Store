import 'package:flutter/material.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

/// Show the tags of a game.
class Tags extends StatelessWidget {

  const Tags({
    required this.tags,
    super.key,
  });

  /// A list of game tags.
  /// 
  /// Used to show a tag label for each game tag.
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 5,
      runSpacing: 5,
      children: tags.map(_tag).toList(),
    );
  }

  /// Build a label [Widget] using the tag name. 
  Widget _tag(String tag) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Palette.foreground.color,
        ),
        height: 27.5,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 1),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            tag,
            style: Typographies.tags(Palette.elements).style,
          ),
        ),
      ),
    );
  }
}