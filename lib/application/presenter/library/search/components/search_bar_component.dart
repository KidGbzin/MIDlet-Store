part of '../search_handler.dart';

/// Creates a search bar [Widget] with a suggestion overlay.
class _SearchBar extends StatefulWidget {

  const _SearchBar({
    required this.controller,
  });

  /// The controller used to manage the [Search] state.
  final _Controller controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final FocusNode _focusNode;
  late OverlayEntry _overlay;

  @override
  void initState() {
    _focusNode = FocusNode()..addListener(() {
      if (_focusNode.hasFocus) {
        _overlay = _createOverlay();
        Overlay.of(context).insert(_overlay);
      }
      else {
        _overlay.remove();
      }
    });
    
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: Palette.foreground.color,
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
                counterText: '',
                hintFadeDuration: Durations.medium2,
              ),
              focusNode: _focusNode,
              maxLength: 30,
              maxLines: 1,
              onSubmitted: (String query) {
                widget.controller.applySearch(query);
              },
              onChanged: (String query) {},
              onTapOutside: (PointerDownEvent event) {
                final bool isPointerInside = isPointerInsideOverlay(
                  pointer: event.position,
                  key: widget.controller.overlayKey,
                );
                if (!isPointerInside) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              style: Typographies.body(Palette.elements).style,
            ),
          ),
          SizedBox.square(
            dimension: 40,
            child: Icon(
              Icons.search_rounded,
              color: Palette.elements.color,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates an overlay entry to display suggestions below the [_SearchBar] widget.
  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
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

  /// Checks if the user taps outside the overlay to unfocus the [TextField].
  /// 
  /// When the [TextField] is focused, an overlay is placed.
  /// If the user touches outside the [TextField], it unfocuses its state before the `onTap` function of the overlay.
  /// 
  /// This function determines if the tap was inside the overlay using a [pointer] and the overlay [key].
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

