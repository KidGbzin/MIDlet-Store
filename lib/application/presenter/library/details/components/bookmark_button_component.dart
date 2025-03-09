part of '../details_handler.dart';

// BOOKMARK BUTTON 🧩: ========================================================================================================================================================== //

/// A [Widget] that creates a bookmark button.
///
/// This button allows users to toggle the bookmark status of a game.
/// It visually indicates whether the game is currently bookmarked.
class _BookmarkButton extends StatefulWidget {

  const _BookmarkButton(this.controller);

  /// Controls the state of the bookmark button.
  final _Controller controller;

  @override
  State<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<_BookmarkButton> {
  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.isFavoriteState,
      builder: (BuildContext context, bool isFavorite, Widget? _) {
        return ButtonWidget.icon(
          iconColor: isFavorite ? ColorEnumeration.pink.value : ColorEnumeration.elements.value,
          icon: HugeIcons.strokeRoundedFavourite,
          onTap: () {
            widget.controller.toggleBookmarkStatus(context, localizations);
          },
        );
      },
    );
  }
}