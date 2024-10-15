part of '../details_handler.dart';

/// A [Widget] that creates a bookmark [Button].
class _Bookmark extends StatelessWidget {

  const _Bookmark({
    required this.controller,
  });

  /// The [Details] controller.
  /// 
  /// The controller that handles the state of the button.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isFavorite,
      builder: (BuildContext context, bool isFavorite, Widget? _) {
        final IconData icon = isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded;
        final String title = controller.game.title.replaceAll(' - ', ': ');
        final String message = isFavorite
          ? '$title has been removed from the favorites.'
          : '$title has been added to the favorites.';

        return Button(
          icon: icon,
          onTap: () {
            final Messenger messenger = Messenger(
              message: message,
            );
            ScaffoldMessenger.of(context).showSnackBar(messenger);
            controller.toggleBookmarkStatus();
          },
        );
      },
    );
  }
}