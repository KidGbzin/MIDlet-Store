part of '../details_handler.dart';

// COVER SECTION 🖼️: ============================================================================================================================================================ //

/// A widget that displays the game's cover image, handling loading and error states.
///
/// This widget fetches and displays the game's cover image from the bucket storage.
class _CoverSection extends StatelessWidget {

  const _CoverSection(this.controller);

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
              borderRadius: BorderRadius.zero,
              image: FileImage(file),
            );
          }
          return Icon(
            HugeIcons.strokeRoundedImage01,
            color: ColorEnumeration.elements.value,
          );
        },
      ),
    );
  }
}