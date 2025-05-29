part of '../details_handler.dart';

class _RelatedGamesSection extends StatefulWidget {

  /// The collection of games to display, consisting of a list of games, their ratings, and thumbnail images.
  final Future<({List<Game> games, List<double> ratings, List<File> thumbnails})> collection;

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// The section'a description.
  final String description;

  /// The section's title.
  final String title;

  const _RelatedGamesSection({
    required this.collection,
    required this.controller,
    required this.description,
    required this.title,
  });

  @override
  State<_RelatedGamesSection> createState() => _RelatedGamesSectionState();
}

class _RelatedGamesSectionState extends State<_RelatedGamesSection> {
  late final double coverHeight;
  late final double coverWidth;

  final double titleHeight = 29;
  final double ratingHeight = 20;

  @override
  void didChangeDependencies() {

    // Calculate the cover image dimensions based on the screen width.
    coverWidth = (MediaQuery.sizeOf(context).width - 60) / 3;
    coverHeight = coverWidth / 0.75;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: widget.description,
      title: widget.title,
      child: Container(
        height: coverHeight + titleHeight + ratingHeight,
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: FutureBuilder(
          future: widget.collection,
          builder: (BuildContext context, AsyncSnapshot<({List<Game> games, List<double> ratings, List<File> thumbnails})> snapshot) {
            final List<Widget> children = <Widget> [];

            if (snapshot.hasData) {
              for (int index = 0; index < snapshot.data!.games.length; index ++) {
                children.add(cover(
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
                  color: Palettes.transparent.value,
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

  Widget cover({
    required File thumbnail,
    required double rating,
    required Game game,
  }) {
    Widget? placeholder;
    DecorationImage? decoration;

    if (thumbnail.path != '/') {
      decoration = DecorationImage(
        image: FileImage(thumbnail),
      );
    }
    else {
      placeholder = Icon(
        Icons.broken_image_rounded,
        color: Palettes.grey.value,
      );
    }

    return SizedBox(
      width: coverWidth,
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
              height: coverHeight,
              width: coverWidth,
              child: placeholder,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              game.title.replaceAll(' - ', ': '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.body(Palettes.elements).style,
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