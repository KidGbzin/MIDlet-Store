import 'package:flutter/material.dart';

import '../../core/configuration/global_configuration.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/tag_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

// TAGS WIDGET 🏷️: ============================================================================================================================================================== //

/// A widget that displays the tags of a game as labels.
///
/// This widget takes a list of tags and displays each tag as a styled label. 
/// Tags are often used to categorize or describe the game, providing users with additional information about the game's genre or features.
class TagsWidget extends StatelessWidget {

  const TagsWidget({
    required this.tags,
    super.key,
  });

  /// A list of game tags.
  /// 
  /// Each tag represents a specific label or category related to the game, such as genre, features, or other descriptors.
  final List<TagEnumeration> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 5,
      runSpacing: 5,
      children: tags.map(_tag).toList(),
    );
  }

  /// Builds a label [Widget] for each tag.
  ///
  /// The tag name is styled inside a [Container] with rounded corners and padding.
  /// The [Text] widget displays the tag name with the specified typography style.
  Widget _tag(TagEnumeration tag) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: gBorderRadius,
          color: ColorEnumeration.foreground.value,
        ),
        height: 35,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          spacing: 7.5,
          children: <Widget>[
            Icon(
              tag.icon,
              color: ColorEnumeration.grey.value,
              size: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                tag.code,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}