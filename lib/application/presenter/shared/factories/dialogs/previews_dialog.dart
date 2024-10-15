part of '../dialogs_factory.dart';

/// Creates a [Dialog] content with a scrollable [PageView] of game screenshots.
class _Previews extends StatefulWidget {

  const _Previews({
    required this.aspectRatio,
    required this.initialPage,
    required this.previews,
  });

  final double aspectRatio;

  /// The initial page of the list.
  ///
  /// Useful to show a specific preview when started.
  final int initialPage;

  /// The list of game screenshots to be shown.
  ///
  /// Each screenshot is represented as a [Uint8List].
  final List<Uint8List> previews;

  @override
  State<_Previews> createState() => _PreviewsState();
}

class _PreviewsState extends State<_Previews> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.sizeOf(context).width - 90) / widget.aspectRatio,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
            child: Thumbnail(
              aspectRatio: widget.aspectRatio,
              image: MemoryImage(widget.previews[index]),
              filterQuality: FilterQuality.none,
            ),
          );
        },
        itemCount: widget.previews.length,
      ),
    );
  }
}