part of '../details_handler.dart';

/// Creates a [Widget] that displays a section of the game's preview images.
class _PreviewsSection extends StatefulWidget {

  const _PreviewsSection({
    required this.controller,
  });

  /// The [Details] controller.
  ///
  /// The controller that manages the state of the preview images.
  final _Controller controller;

  @override
  State<_PreviewsSection> createState() => _PreviewsSectionState();
}

class _PreviewsSectionState extends State<_PreviewsSection> {
  late final double _coverHeight;
  late final double _coverWidth;

  @override
  void didChangeDependencies() {
  
     // Calculate cover dimensions based on screen width, maintaining a 4:3 aspect ratio.
    _coverWidth = (MediaQuery.sizeOf(context).width - 60) / 3;
    _coverHeight = _coverWidth / 0.75;
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: AppLocalizations.of(context)!.sectionPreviewsDescription,
      title: AppLocalizations.of(context)!.sectionPreviews,
      child: FutureBuilder<List<Uint8List>>(
        future: widget.controller.previews,
        builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
          Widget child = SizedBox(
            height: _coverHeight,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.downloading_rounded,
                color: ColorEnumeration.elements.value,
              ),
            ),
          );

          // SUCCESS:
          if (snapshot.hasData) {
            child = _buildPreviews(snapshot.data!);
          } 

          // FAILURE:
          else if (snapshot.hasError) {
            Logger.error.print(
              label: 'Details | Previews',
              message: '${snapshot.error}',
              stackTrace: snapshot.stackTrace,
            );
            child = Container(
              height: _coverHeight,
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 7.5,
                children: <Widget> [
                  Icon(
                    Icons.broken_image_rounded,
                    color: ColorEnumeration.grey.value,
                  ),
                  Text(
                    AppLocalizations.of(context)!.sectionPreviewsError,
                    style: TypographyEnumeration.body(ColorEnumeration.grey).style,
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

  /// Creates a widget displaying a row of preview images.
  ///
  /// The function takes a list of preview images, decodes the first one to get the aspect ratio, and returns a row of three preview thumbnails.
  /// It automatically calculates the height based on the screen width and the aspect ratio of the first preview image.
  Widget _buildPreviews(List<Uint8List> previews) {

    // Decode the first preview image to extract its aspect ratio.
    final image.Image? frame = image.decodeImage(previews.first);
    final double aspectRatio = frame!.width / frame.height;

    return Container(
      height: (MediaQuery.of(context).size.width - 60) / 3 / aspectRatio, // Calculate height based on aspect ratio
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          _buildThumbnail(
            aspectRatio: aspectRatio,
            index: 0,
            previews: previews,
          ),
          _buildThumbnail(
            aspectRatio: aspectRatio,
            index: 1,
            previews: previews,
          ),
          _buildThumbnail(
            aspectRatio: aspectRatio,
            index: 2,
            previews: previews,
          ),
        ],
      ),
    );
  }

  /// Creates a preview thumbnail widget.
  ///
  /// This widget represents a single preview thumbnail in the row. It displays the image and allows the user to tap on it to show a larger preview in a dialog.
  Widget _buildThumbnail({
    required double aspectRatio,
    required int index,
    required List<Uint8List> previews,
  }) {
    return ThumbnailWidget(
      aspectRatio: aspectRatio,
      image: MemoryImage(previews[index]),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _PreviewsDialog(
              aspectRatio: aspectRatio,
              initialPage: index,
              previews: previews,
            );
          },
        );
      },
    );
  }
}