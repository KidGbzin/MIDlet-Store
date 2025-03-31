part of '../details_handler.dart';

// PREVIEWS DIALOG 🧩: ========================================================================================================================================================== //

/// A [Dialog] that displays a scrollable [PageView] of game screenshots.
///
/// This widget allows users to swipe through multiple game screenshots.
class _PreviewsDialog extends StatefulWidget {

  const _PreviewsDialog({
    required this.aspectRatio,
    required this.initialPage,
    required this.previews,
  });

  /// The aspect ratio of the screenshots.
  ///
  /// Used to maintain the correct image proportions when displayed.
  final double aspectRatio;

  /// The index of the initial screenshot to display.
  ///
  /// Defines which screenshot is shown first when the dialog is opened.
  final int initialPage;

  /// A list of game screenshots to be displayed.
  ///
  /// Each screenshot is represented as a [Uint8List] containing the raw image data.
  final List<Uint8List> previews;

  @override
  State<_PreviewsDialog> createState() => _PreviewsDialogState();
}

class _PreviewsDialogState extends State<_PreviewsDialog> {
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
    return DialogWidget(
      color: ColorEnumeration.transparent.value,
      width: double.infinity,
      child: _buildChild(context),
    );
  }

  /// Builds the scrollable screenshot gallery inside the dialog.
  Widget _buildChild(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.sizeOf(context).width - 90) / widget.aspectRatio,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.previews.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
            child: ThumbnailWidget(
              aspectRatio: widget.aspectRatio,
              image: MemoryImage(widget.previews[index]),
              filterQuality: FilterQuality.none,
            ),
          );
        },
      ),
    );
  }
}