part of '../search_handler.dart';

// LIST VIEW 🧩: ================================================================================================================================================================ //

/// Creates a [Widget] that lists the given game collection.
///
/// This widget uses a [ListView] to display a list of games.
/// It accepts a collection of [games] and a [controller] that handles the state of the list view.
/// Each game in the collection is displayed using a [ListTile] widget, which shows the game cover, title, description, and other details.
class _ListView extends StatelessWidget {

  const _ListView({
    required this.controller,
    required this.games,
  });

  /// The [Search] controller that manages the state of the [ListView].
  /// 
  /// The controller is responsible for managing the actions and state of the list, including filtering and updating the displayed games.
  final _Controller controller;

  /// The collection of [games] to be shown in the list.
  /// 
  /// This is a list of [Game] objects that will be displayed in the list, one for each item.
  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _ListTile(
          controller: controller,
          game: games[index],
        );
      },
      itemCount: games.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: ColorEnumeration.divider.value,
          height: 1,
          thickness: 1,
        );
      },
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
      onTap: () => context.push(
        '/details',
        extra: widget.game,
      ),
      child: FutureBuilder(
        future: widget.controller.getGameData(widget.game),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          double averageRating = 0.0;
          int downloads = 0;

          if (snapshot.hasData) {
            averageRating = snapshot.data!["Average-Rating"];
            downloads = snapshot.data!["Downloads"];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.fromLTRB(15 - 1, 25, 15, 0), // The headline font is a pixel off.
                child: Text(
                  widget.game.title.replaceFirst(' -', ':').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
                child: Text(
                  TagEnumeration.fromList(localizations, widget.game.tags).reduce((x, y) => "$x • $y"),
                  style: TypographyEnumeration.body(ColorEnumeration.grey).style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    _buildLeadingInformation(averageRating),
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
                  style: TypographyEnumeration.body(ColorEnumeration.grey).style,
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  /// Builds a thumbnail widget displaying the cover image of the given game.  
  ///
  /// This widget asynchronously loads and displays the game's cover image.  
  /// If the image is successfully retrieved, it is shown inside a [ThumbnailWidget] widget.  
  /// If an error occurs or the image is unavailable, a fallback icon is displayed.
  ///
  /// Additionally, the game's average rating is fetched asynchronously and displayed using the [RatingStarsWidget] widget.
  Widget _buildLeadingInformation(double averageRating) {
    return Column(
      spacing: 7.5,
      children: <Widget> [
        SizedBox(
          height: 142.5,
          child: AspectRatio(
            aspectRatio: 0.75,
            child: FutureBuilder<File>(
              future: widget.controller.getCover(widget.game.title),
              builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                late final Widget child;
                
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    child = ThumbnailWidget(
                      image: FileImage(snapshot.data!),
                    );
                  }
                  else if (snapshot.hasError) {
                    Logger.error.print(
                      label: 'Search | Game Tile\'s Cover',
                      message: '${snapshot.error}',
                      stackTrace: snapshot.stackTrace,
                    );
                    child = HugeIcon(
                      icon: HugeIcons.strokeRoundedSettingError03,
                      color: ColorEnumeration.grey.value,
                    );
                  }
                }
                else {
                  child = LoadingWidget();
                }
                return AnimatedSwitcher(
                  duration: Durations.extralong4,
                  child: child,
                );
              },
            ),
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
              color: ColorEnumeration.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.labelPublisher}: ${widget.game.publisher}" ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              color: ColorEnumeration.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.labelRelease}: ${widget.game.release}" ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedJava,
              color: ColorEnumeration.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " MIDlets: ${widget.game.midlets.length}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDownload01,
              color: ColorEnumeration.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.labelDownloads}: $downloads",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            HugeIcon(
              icon: HugeIcons.strokeRoundedAward01,
              color: ColorEnumeration.grey.value,
              size: 18,
            ),
            Expanded(
              child: Text(
                " ${localizations.labelAchievements}: 0",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
      ],
    );
  }
}