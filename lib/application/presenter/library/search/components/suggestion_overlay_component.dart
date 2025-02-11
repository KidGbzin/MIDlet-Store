part of '../search_handler.dart';

// SUGGESTION OVERLAY 🧩: ======================================================================================================================================================= //

/// A widget that displays an overlay of game suggestions when the search bar is focused.
///
/// This widget is designed to be shown when the search bar is in focus.
/// It displays a list of game suggestions dynamically, with a limit on the number of visible items (maximum of 9).
/// The overlay is managed by a controller that handles the state of the suggestions list and provides interactivity with the search bar.
///
/// The widget uses a [ValueListenableBuilder] to listen for changes in the list of game suggestions and update the UI accordingly.
/// The list is shown inside a scrollable container with a maximum height of 400 pixels to ensure the overlay doesn't take up too much space.
class _SuggestionOverlay extends StatefulWidget {

  const _SuggestionOverlay({
    required this.controller,
  });

  /// The controller responsible for managing the state of the suggestions and overlay.
  ///
  /// This controller provides the list of game suggestions and the key for the overlay, which is shared with the search bar to ensure proper positioning and interaction.
  final _Controller controller;

  @override
  State<_SuggestionOverlay> createState() => _SuggestionOverlayState();
}

class _SuggestionOverlayState extends State<_SuggestionOverlay> with WidgetsBindingObserver {
  late final GlobalKey _key;

  @override
  void initState() {
    _key = GlobalKey(
      debugLabel: "OVERLAY_KEY",
    );

    // Set the overlay key in the controller to be shared with the search bar.
    widget.controller.overlayKey = _key;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 0,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: ColorEnumeration.foreground.value,
      ),
      key: _key,
      child: ValueListenableBuilder(
        valueListenable: widget.controller.gemeSuggestionsList,
        builder: (BuildContext context, List<Game> suggestions, Widget? _) {
          return ListView.builder(
            itemCount: _itemCount(suggestions.length),
            padding: suggestions.isNotEmpty ? EdgeInsets.fromLTRB(0, 7.5, 0, 7.5) : EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _SuggestionTile(
                game: suggestions[index],
              );
            },
          );
        }
      ),
    );
  }

  /// Limits the number of items displayed in the list to a maximum of 9.
  ///
  /// This method ensures that no more than 9 game suggestions are shown in the overlay.
  /// If there are more than 9 suggestions, the excess items will be hidden.
  int _itemCount(int length) {
    if (length > 9) {
      return 9;
    }
    return length;
  }
}

// SUGGESTION TILE 🧩: ========================================================================================================================================================== //

/// A tile widget representing a suggested game, which can be tapped to navigate to the game's details page.
class _SuggestionTile extends StatelessWidget {

  const _SuggestionTile({
    required this.game,
  });

  /// The [Game] object representing the suggested game.
  /// 
  /// This game is displayed in the suggestion tile and can be tapped for more details.
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorEnumeration.transparent.value,
      surfaceTintColor: ColorEnumeration.transparent.value,
      child: InkWell(
        onTap: () {
          context.push(
            '/details',
            extra: game,
          ).then((_) {
            FocusManager.instance.primaryFocus?.unfocus(); // Navigate to the game details page and unfocus any active input fields.
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  game.title.replaceAll(' - ', ': '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.body(ColorEnumeration.elements).style,
                ),
              ),
            ),
            SizedBox.square(
              dimension: 40,
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedClock04,
                color: ColorEnumeration.elements.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}