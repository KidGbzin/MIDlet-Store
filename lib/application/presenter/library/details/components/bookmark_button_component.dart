part of '../details_handler.dart';

/// A [Widget] that creates a bookmark [ButtonWidget].
///
/// This button allows users to bookmark or unbookmark a game, visually indicating the current state.
class _BookmarkButton extends StatelessWidget {

  const _BookmarkButton({
    required this.controller,
  });

  /// Controls the state of the bookmark button.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isFavoriteState,
      builder: (BuildContext context, bool isFavorite, Widget? _) {
        return ButtonWidget.icon(
          iconColor: isFavorite ? ColorEnumeration.pink.value : ColorEnumeration.elements.value,
          icon: HugeIcons.strokeRoundedFavourite,
          onTap: controller.toggleBookmarkStatus,
        );
      },
    );
  }
}