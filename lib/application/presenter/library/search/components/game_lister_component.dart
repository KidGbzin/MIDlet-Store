part of '../search_handler.dart';

/// Creates a [Widget] that lists the given game collection.
class _GameLister extends StatelessWidget {

  const _GameLister({
    required this.controller,
    required this.games,
  });

  /// The [Search] controller.
  /// 
  /// The controller that handles the state of the [ListView].
  final _Controller controller;

  /// The game collection to be shown.
  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _GameTile(
          controller: controller,
          game: games[index],
        );
      },
      itemCount: games.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Palette.divider.color,
          height: 1,
          thickness: 1,
        );
      },
    );
  }
}