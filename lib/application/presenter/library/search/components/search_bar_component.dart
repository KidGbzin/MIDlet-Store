part of '../search_handler.dart';

// SEARCH BAR 🔍: =============================================================================================================================================================== //

/// A widget that creates a search bar with a suggestion overlay.
///
/// This widget allows the user to input a search query while displaying a list of suggestions below the search bar when it is focused.
/// The overlay is managed dynamically based on the focus state of the search bar, and it will be shown or hidden accordingly.
class _SearchBar extends StatefulWidget {

  const _SearchBar(this.controller);

  /// The controller used to manage the [Search] state.
  /// 
  /// This controller handles the logic for managing the search query, applying filters, and controlling the suggestions displayed in the overlay.
  final _Controller controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final FocusNode focusNode;
  late final AppLocalizations localizations;

  late OverlayEntry overlay;

  @override
  void initState() {

    // Initialize the focus node and add a listener to handle focus changes.
    focusNode = FocusNode()
      ..addListener(() {
        if (focusNode.hasFocus) {
          overlay = _createOverlay();
          Overlay.of(context).insert(overlay);
        }
        else {
          overlay.remove();
        }
      });
    
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: gBorderRadius,
        color: ColorEnumeration.foreground.value,
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Expanded(
            child: TextField(
              controller: widget.controller.textController,
              cursorHeight: 20,
              cursorOpacityAnimates: true,
              cursorRadius: const Radius.circular(100),
              cursorWidth: 2.5,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(15, 0, 2.5, 7),
                counterText: "",
                hintFadeDuration: Durations.medium2,
              ),
              focusNode: focusNode,
              maxLength: 30,
              maxLines: 1,
              onSubmitted: (String query) {
                widget.controller.clearFilters(context, localizations, false);
                widget.controller.applySearch(query);
              },
              onChanged: (String query) {},
              onTapOutside: (PointerDownEvent event) {

                // If tap is outside the overlay, unfocus the search bar.
                final bool isPointerInside = isPointerInsideOverlay(
                  pointer: event.position,
                  key: widget.controller.overlayKey,
                );
                if (!isPointerInside) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              style: TypographyEnumeration.body(ColorEnumeration.elements).style,
            ),
          ),
          SizedBox.square(
            dimension: 40,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch02,
              color: ColorEnumeration.elements.value,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates an overlay entry that displays a list of game suggestions below the [_SearchBar] widget.
  /// 
  /// This method calculates the position of the [_SearchBar] widget using its [RenderBox] and determine where the overlay should be placed relative to the [TextField].
  /// It positions the overlay directly below the search bar with an additional 7.5 pixel offset to give some spacing between the search bar and the suggestions.
  /// The overlay will display the [_SuggestionOverlay] widget, which contains the suggestions list.
  /// 
  /// Returns an [OverlayEntry] that can be inserted into the overlay stack.
  OverlayEntry _createOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 7.5,
        width: size.width,
        child: _SuggestionOverlay(
          controller: widget.controller,
        ),
      ),
    );
  }

  /// Checks if the user taps inside the overlay to determine if the [TextField] should be unfocused.
  /// 
  /// When the [TextField] is focused and the overlay is displayed, if the user taps outside the [TextField], it will unfocus before triggering the `onTap` function of the overlay.
  /// This method checks if the tap occurred inside the overlay by comparing the tap's position with the bounds of the overlay.
  /// 
  /// The position of the overlay is determined using the [key] associated with the overlay widget, and the tap position is provided by the [pointer] offset.
  ///
  /// Returns `true` if the tap is inside the overlay, `false` otherwise.
  bool isPointerInsideOverlay({
    required GlobalKey key,
    required Offset pointer,
  }) {
    final RenderBox? render = key.currentContext?.findRenderObject() as RenderBox?;

    if (render != null) {
      final Offset topLeft = render.localToGlobal(Offset.zero);
      final Offset bottomRight = topLeft + render.size.bottomRight(Offset.zero);

      final bool isPointerInside = (pointer.dx >= topLeft.dx) && 
                                   (pointer.dx <= bottomRight.dx) &&
                                   (pointer.dy >= topLeft.dy) && 
                                   (pointer.dy <= bottomRight.dy);

      return isPointerInside;
    }

    return false;
  }
}