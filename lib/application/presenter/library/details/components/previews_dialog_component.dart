part of '../details_handler.dart';

class _PreviewsDialog extends StatefulWidget {

  /// The aspect ratio used to constrain each preview image.
  final double aspectRatio;

  /// The list of preview images to display.
  /// Each image is represented as a [Uint8List].
  final List<Uint8List> previews;

  /// The index of the image to display first when the dialog is opened.
  final int startIndex;

  const _PreviewsDialog({
    required this.aspectRatio,
    required this.previews,
    required this.startIndex,
  });

  @override
  State<_PreviewsDialog> createState() => _PreviewsDialogState();
}

class _PreviewsDialogState extends State<_PreviewsDialog> {
  late final PageController controller;
  late final double screenWidth = MediaQuery.sizeOf(context).width;

  @override
  void initState() {
    controller = PageController(
      initialPage: widget.startIndex,
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 7.5,
        sigmaY: 7.5,
      ),
      child: Dialog(
        alignment: Alignment.center,
        backgroundColor: Palettes.transparent.value,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: gBorderRadius,
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenWidth - 90,
          ),
          width: double.infinity,
          child: child(context),
        ),
      ),
    );
  }

  Widget child(BuildContext context) {
    return SizedBox(
      height: (screenWidth - 90) / widget.aspectRatio,
      child: PageView.builder(
        controller: controller,
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