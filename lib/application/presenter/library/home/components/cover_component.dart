part of '../home_handler.dart';

/// Creates a [Widget] that shows the game cover image.
class _Cover extends StatelessWidget {

  const _Cover({
    required this.controller,
    required this.title,
  });

  /// The [Home] controller.
  /// 
  /// The controller that handles the state of the thumbnails.
  final _Controller controller;

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          return Thumbnail(
            image: FileImage(snapshot.data!),
            filterQuality: FilterQuality.high,
            onTap: () => context.push('/details/$title'),
          );
        }
        else if (snapshot.hasError) {
          if (snapshot.error is ResponseException) {
            final ResponseException exception = snapshot.error as ResponseException;
            Logger.error.print(
              label: 'Home | Component • Cover Section',
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
      future: controller.thumbnail(title),
    );
  }
}