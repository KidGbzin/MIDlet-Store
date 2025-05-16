part of '../details_handler.dart';

// RELATED GAMES SECTION 🎮: ==================================================================================================================================================== //

/// A section widget displaying a collection of related games or games from the same publisher.
///
/// This widget fetches and displays a list of games that are either related to the current game or belong to the same publisher.
/// It includes a title, description, and a list of cover images for each game, along with their ratings.
class _RelatedGamesSection extends StatefulWidget {

  const _RelatedGamesSection({
    required this.collection,
    required this.controller,
    required this.description,
    required this.title,
  });

  /// The section's title.
  final String title;

  /// The section'a description.
  final String description;

  /// The collection of games to display, consisting of a list of games, their ratings, and thumbnail images.
  final Future<({List<Game> games, List<double> ratings, List<File> thumbnails})> collection;

  /// The [Details] controller.
  ///
  /// The controller that manages the state of the related games.
  final _Controller controller;

  @override
  State<_RelatedGamesSection> createState() => _RelatedGamesSectionState();
}

class _RelatedGamesSectionState extends State<_RelatedGamesSection> {
  late final double _coverHeight;
  late final double _coverWidth;

  final double _titleHeight = 29;
  final double _ratingHeight = 20;

  @override
  void didChangeDependencies() {

    // Calculate the cover image dimensions based on the screen width.
    _coverWidth = (MediaQuery.sizeOf(context).width - 60) / 3;
    _coverHeight = _coverWidth / 0.75;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: widget.description,
      title: widget.title,
      child: Container(
        height: _coverHeight + _titleHeight + _ratingHeight,
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: FutureBuilder(
          future: widget.collection,
          builder: (BuildContext context, AsyncSnapshot<({List<Game> games, List<double> ratings, List<File> thumbnails})> snapshot) {
            final List<Widget> children = <Widget> [];

            if (snapshot.hasData) {
              for (int index = 0; index < snapshot.data!.games.length; index ++) {
                children.add(_buildCoverImage(
                  rating: snapshot.data!.ratings[index],
                  thumbnail: snapshot.data!.thumbnails[index],
                  game: snapshot.data!.games[index],
                ));
              }
            }
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) => children[index],
              itemCount: children.length,
              separatorBuilder: (BuildContext context, int index) {
                return VerticalDivider(
                  width: 15,
                  color: ColorEnumeration.transparent.value,
                );
              },
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              scrollDirection: Axis.horizontal,
            );
          }
        ),
      ),
    );
  }

  /// Builds the cover image widget for each game, including the image, title, and rating.
  ///
  /// If the thumbnail is unavailable, a placeholder icon will be displayed instead of the image.
  Widget _buildCoverImage({
    required File thumbnail,
    required double rating,
    required Game game,
  }) {
    Widget? placeholder;
    DecorationImage? decoration;

    // If thumbnail path is not empty, use it as the decoration image.
    if (thumbnail.path != '/') {
      decoration = DecorationImage(
        image: FileImage(thumbnail),
      );
    }
    else {
      placeholder = Icon(
        Icons.broken_image_rounded,
        color: ColorEnumeration.grey.value,
      );
    }

    return SizedBox(
      width: _coverWidth,
      child: Column(
        children: <Widget>[
          InkWell(
            borderRadius: gBorderRadius,
            onTap: () => context.gtDetails(
              game: game,
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: gBorderRadius,
                boxShadow: kElevationToShadow[3],
                image: decoration,
              ),
              height: _coverHeight,
              width: _coverWidth,
              child: placeholder,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              game.title.replaceAll(' - ', ': '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.body(ColorEnumeration.elements).style,
              textAlign: TextAlign.center,
            ),
          ),
          RatingStarsWidget(
            rating: rating,
          ),
        ],
      ),
    );
  }
}