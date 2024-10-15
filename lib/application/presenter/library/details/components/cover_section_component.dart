part of '../details_handler.dart';

/// Creates a [Widget] that shows the game cover image.
class _Cover extends StatelessWidget {

  const _Cover({
    required this.controller,
  });

  /// The [Details] controller.
  /// 
  /// The controller that handles the state of the thumbnails.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width / 0.75,
      width: double.infinity,
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData) {
            return Thumbnail(
              borderRadius: BorderRadius.zero,
              image: FileImage(snapshot.data!),
              filterQuality: FilterQuality.none,
            );
          }
          else if (snapshot.hasError) {
            if (snapshot.error is ResponseException) {
              final ResponseException exception = snapshot.error as ResponseException;
              Logger.error.print(
                label: 'Details | Component • Cover Section',
                message: exception.message,
              );
            }
            return Icon(
              Icons.broken_image_rounded,
              color: Palette.grey.color,
            );
          }
          else {
            return Icon(
              Icons.downloading_rounded,
              color: Palette.elements.color,
            );
          }
        },
        future: controller.thumbnail,
      ),
    );
  }
}