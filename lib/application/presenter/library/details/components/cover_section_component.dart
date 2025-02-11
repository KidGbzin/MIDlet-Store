part of '../details_handler.dart';

/// A widget that displays the game's cover image, handling loading and error states.
///
/// This widget listens to changes in the cover image state and updates the UI accordingly.
class _Cover extends StatelessWidget {

  const _Cover({
    required this.controller,
  });

  /// Controls the state of the game's cover image.
  ///
  /// Responsible for fetching and providing the thumbnail image.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width / 0.75,
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: controller.thumbnailState,
        builder: (BuildContext context, File? file, Widget? _) {
          if (file != null) {
            return ThumbnailWidget(
              border: const Border(),
              borderRadius: BorderRadius.zero,
              image: FileImage(file),
            );
          }
          return Icon(
            Icons.image_rounded,
            color: ColorEnumeration.elements.value,
          );
        },
      ),
    );
  }
}