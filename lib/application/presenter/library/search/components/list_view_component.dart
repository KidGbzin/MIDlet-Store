part of '../search_handler.dart';

class _ListView extends StatelessWidget {

  final _Controller controller;

  final List<Game> games;

  const _ListView({
    required this.controller,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        if (games.length >= 6) controller.preloadNearbyAdvertisements(index);

        if ((index + 1) % 6 == 0) {
          return Advertisement.banner(controller.getAdvertisementByIndex(index));
        }

        final int iGame = index - (index ~/ 6);

        return _GameTile(
          controller: controller,
          game: games[iGame],
        );
      },
      itemCount: games.length + (games.length ~/ 5),
      separatorBuilder: (BuildContext _, int __) => gDivider
    );
  }
}