part of '../search_handler.dart';

/// Creates a [Widget] tile that shows a breaf game information.
class _GameTile extends StatelessWidget {

  const _GameTile({
    required this.controller,
    required this.game,
  });

  /// The [Search] controller.
  /// 
  /// The [controller] that handles the state of the tile.
  final _Controller controller;

  /// The [game] to be shown on the tile.
  final Game game;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/details/${game.title}'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: Stack(
          children: <Widget> [
            SizedBox(
              height: 135,
              child: Row(
                children: <Widget> [
                  _thumbnail(),
                  VerticalDivider(
                    color: Palette.transparent.color,
                    width: 15,
                  ),
                  Expanded(
                    child: _details(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Text(
                game.description ?? "",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Typographies.body(Palette.grey).style,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a thumbnail [Widget] from the given [game].
  Widget _thumbnail() {
    return AspectRatio(
      aspectRatio: 0.75,
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          final Widget child;
          if (snapshot.hasData) {
            child = Thumbnail(
              image: FileImage(snapshot.data!),
            );
          }
          else if (snapshot.hasError) {
            if (snapshot.error is ResponseException) {
              final ResponseException exception = snapshot.error as ResponseException;
              Logger.error.print(
                label: 'Search | Component • Game Tile',
                message: exception.message,
              );
            }
            child = Icon(
              Icons.broken_image_rounded,
              color: Palette.grey.color,
            );
          }
          else {
            child = Icon(
              Icons.downloading_rounded,
              color: Palette.elements.color,
            );
          }
          return AnimatedSwitcher(
            duration: Durations.medium2,
            child: child,
          );
        },
        future: controller.getCover(game.title),
      ),
    );
  }

  /// Creates the tile body with the [game] information.
  Widget _details(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Text(
          game.title.toUpperCase().replaceAll(' - ', ': '),
          style: Typographies.headline(Palette.elements).style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 10, 0, 0),
          child: Text(
            '${game.release} • ${game.publisher}',
            style: Typographies.body(Palette.elements).style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 7.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              const Rating(
                rating: 0,
              ),
              Text(
                ' • 0.00',
                style: Typographies.tags(Palette.grey).style,
              )
            ],
          ),
        ),
        Tags(
          tags: game.tags,
        ),
      ],
    );
  }
}