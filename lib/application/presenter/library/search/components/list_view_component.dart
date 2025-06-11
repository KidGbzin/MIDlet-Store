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
        controller.sAdMob.preloadNearbyAdvertisements(index, AdSize.mediumRectangle);

        if ((index + 1) % 6 == 0) {
          return Advertisement.banner(
            advertisement: controller.sAdMob.getAdvertisementByIndex(index),
          );
        }

        final int iGame = index - (index ~/ 6);

        return _ListTile(
          controller: controller,
          game: games[iGame],
        );
      },
      itemCount: games.length + (games.length ~/ 5),
      separatorBuilder: (BuildContext _, int __) => gDivider
    );
  }
}

// LIST TILE 🧩: ================================================================================================================================================================ //

/// A widget tile that displays brief information about a game.
///
/// This widget is designed to show game details in a concise manner as part of a list view.
/// It includes interaction capabilities, allowing users to tap the tile to navigate to the game's detail page.
/// The tile fetches additional game data such as average rating and download count from a controller.
class _ListTile extends StatefulWidget {

  const _ListTile({
    required this.controller,
    required this.game,
  });

  /// The controller responsible for managing the state and interactions of the tile.
  ///
  /// This controller handles fetching additional game data and updating the UI accordingly.
  final _Controller controller;

  /// The game data to be displayed on the tile.
  ///
  /// This includes the game's title, cover image, and other relevant details.
  final Game game;

  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.gtDetails(
        game: widget.game,
      ),
      child: FutureBuilder(
        future: Future.wait([
          widget.controller.getCover(widget.game.title),
          widget.controller.getGameData(widget.game),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          double averageRating = 0.0;
          File? cover;
          int downloads = 0;

          if (snapshot.hasData) {
            averageRating = snapshot.data![1]["Average-Rating"];
            cover = snapshot.data![0];
            downloads = snapshot.data![1]["Downloads"];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 25, 15, 0), // The headline font is misaligned by a single pixel.
                child: Text(
                  widget.game.title.replaceFirst(' -', ':').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
                child: Text(
                  TagEnumeration.fromList(localizations, widget.game.tags).reduce((x, y) => "$x • $y"),
                  style: TypographyEnumeration.body(Palettes.grey).style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    _buildLeadingInformation(cover, averageRating),
                    Expanded(
                      child: _buildGameDetails(downloads),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Text(
                  widget.game.description(Localizations.localeOf(context)) ?? "",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.body(Palettes.grey).style,
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  /// Builds a leading information section for the given game.  
  ///
  /// This widget presents two key pieces of information about the game:
  /// - **Cover**: The cover image of the game, or a fallback icon if the image is unavailable.
  /// - **Average Rating**: The average rating of the game, represented as a row of stars.
  ///
  /// This widget asynchronously loads and displays the game's cover image.  
  /// If the image is successfully retrieved, it is shown inside a [ThumbnailWidget] widget.  
  /// If an error occurs or the image is unavailable, a fallback icon is displayed.
  Widget _buildLeadingInformation(File? cover, double averageRating) {
    late final Widget thumbnail;

    if (cover != null) {
      thumbnail = ThumbnailWidget(
        image: FileImage(cover),
      );
    }

    else {
      thumbnail = HugeIcon(
        icon: HugeIcons.strokeRoundedImage01,
        color: Palettes.grey.value,
        size: 18,
      );
    }
    return Column(
      spacing: 7.5,
      children: <Widget> [
        SizedBox(
          height: 142.5,
          child: AspectRatio(
            aspectRatio: 0.75,
            child: thumbnail,
          ),
        ),
        RatingStarsWidget(
          rating: averageRating,
        ),
      ],
    );
  }

  /// Builds a detailed information section for the given game.  
  ///
  /// This widget presents various game details, including:
  /// - **Publisher**: The name of the game's publisher.
  /// - **Release Date**: The official release date.
  /// - **MIDlets Count**: The number of Java MIDlets available.
  /// - **Downloads**: The total number of downloads.
  /// - **Achievements**: The number of achievements available in the game.
  ///
  /// Each detail is displayed in a row with an icon and a corresponding label, ensuring readability and consistent layout.
  Widget _buildGameDetails(int downloads) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 7.5,
      children: <Widget> [
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCorporate,
              color: Palettes.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.lbPublisher}: ${widget.game.publisher}" ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              color: Palettes.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.lbRelease}: ${widget.game.release}" ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedJava,
              color: Palettes.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " MIDlets: ${widget.game.midlets.length}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDownload01,
              color: Palettes.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.lbDownloads}: $downloads",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedAward01,
              color: Palettes.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.lbAchievements}: -",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ),
          ],
        ),
      ],
    );
  }
}