part of '../details_handler.dart';

class _CoverSection extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _CoverSection(this.controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width / 0.75,
      child: ValueListenableBuilder(
        valueListenable: controller.thumbnailState,
        builder: (BuildContext context, File? file, Widget? _) {
          if (file != null) {
            return ThumbnailWidget(
              borderRadius: BorderRadius.zero,
              image: FileImage(file),
              showShadow: false,
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