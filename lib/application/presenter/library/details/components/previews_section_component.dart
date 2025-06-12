part of '../details_handler.dart';

class _PreviewsSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _PreviewsSection({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_PreviewsSection> createState() => _PreviewsSectionState();
}

class _PreviewsSectionState extends State<_PreviewsSection> {
  late double coverHeight;
  late double coverWidth;

  @override
  void didChangeDependencies() {
    // Calculate cover dimensions based on screen width, maintaining a 4:3 aspect ratio.
    coverWidth = (MediaQuery.sizeOf(context).width - 60) / 3;
    coverHeight = coverWidth / 0.75;
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: widget.localizations.scPreviewsDescription,
      title: widget.localizations.scPreviews,
      child: FutureBuilder<List<Uint8List>>(
        future: widget.controller.previews,
        builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
          Widget child = SizedBox(
            height: coverHeight,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.downloading_rounded,
                color: Palettes.elements.value,
              ),
            ),
          );

          if (snapshot.hasData) {
            child = previews(snapshot.data!);
          } 

          else if (snapshot.hasError) {
            child = Container(
              height: coverHeight,
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    Icons.broken_image_rounded,
                    color: Palettes.grey.value,
                  ),
                  Text(
                    widget.localizations.scPreviewsError,
                    style: TypographyEnumeration.body(Palettes.grey).style,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } 

          return AnimatedSwitcher(
            duration: Durations.extralong4,
            child: child,
          );
        },
      ),
    );
  }

  Widget previews(List<Uint8List> previews) {
    final image.Image? frame = image.decodeImage(previews.first);
    final double aspectRatio = frame!.width / frame.height;

    return Container(
      height: (MediaQuery.of(context).size.width - 60) / 3 / aspectRatio,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          thumbnail(
            aspectRatio: aspectRatio,
            index: 0,
            previews: previews,
          ),
          thumbnail(
            aspectRatio: aspectRatio,
            index: 1,
            previews: previews,
          ),
          thumbnail(
            aspectRatio: aspectRatio,
            index: 2,
            previews: previews,
          ),
        ],
      ),
    );
  }

  Widget thumbnail({
    required double aspectRatio,
    required int index,
    required List<Uint8List> previews,
  }) {
    return ThumbnailWidget(
      aspectRatio: aspectRatio,
      image: MemoryImage(previews[index]),
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: "Previews Dialog",
          transitionDuration: gAnimationDuration,
          pageBuilder: (BuildContext context, Animation<double> _, Animation<double> __) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: _PreviewsDialog(
                aspectRatio: aspectRatio,
                startIndex: index,
                previews: previews,
              )
            );
          },
          transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> __, Widget child) {
            final CurvedAnimation curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}