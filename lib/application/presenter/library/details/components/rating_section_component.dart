part of '../details_handler.dart';

class _RatingSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _RatingSection({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_RatingSection> createState() => __RatingSectionState();
}

class __RatingSectionState extends State<_RatingSection> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.nGameMetadata,
      builder: (BuildContext context, GameMetadata? metadata, Widget? _) {
        final Map<String, int> emptyStars = <String, int> {
          "5": 0,
          "4": 0,
          "3": 0,
          "2": 0,
          "1": 0,
        };
    
        return InkWell(
          onTap: () {
            if (metadata != null) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) => _SubmitRatingModal(
                  controller: widget.controller,
                  localizations: widget.localizations
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      duration: Durations.extralong4,
                      child: metadata == null ? loading() : leadingScore(metadata.averageRating!, metadata.totalRatings!),
                    ),
                  ),
                  Expanded(
                    child: ratingBarsGraph(metadata == null ? emptyStars : metadata.stars!),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget loading() => SizedBox.square(
    key: Key("Loading"),
    dimension: 95,
    child: LoadingAnimation(),
  );

  Widget leadingScore(double averageRating, int ratingsCount) {
    return SizedBox(
      key: Key("Leading-Score"),
      width: 95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: <Widget> [
          Text(
            averageRating == 0 ? '-' : '$averageRating',
            style: TypographyEnumeration.rating(Palettes.elements).style,
          ),
          RatingStarsWidget(
            rating: averageRating,
            starSize: 17.5,
          ),
          Text(
            '$ratingsCount',
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ],
      ),
    );
  }

  Widget ratingBarsGraph(Map<String, int> starsCount) {
    final int totalRatings = (starsCount["5"]! + starsCount["4"]! + starsCount["3"]! + starsCount["2"]! + starsCount["1"]!);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget> [
        for (int index = 5; index >= 1; index --) starTile(
          stars: index,
          starRatingCount: starsCount["$index"]!,
          totalRatingsCount: totalRatings,
        ),
      ],
    );
  }

  Widget starTile({
    required int stars,
    required int starRatingCount,
    required int totalRatingsCount,
  }) {
    final double percentage = totalRatingsCount == 0 ? 0 : starRatingCount / totalRatingsCount;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            RatingStarsWidget(
              rating: stars.toDouble(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Stack(
                  children: <Widget> [
                    backgroundStarTile(),
                    foregroundStarTile(percentage),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget backgroundStarTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Palettes.foreground.value,
      ),
      height: 10,
    );
  }

  Widget foregroundStarTile(double percentage) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            curve: Curves.easeOutCubic,
            duration: Durations.extralong4,
            height: 10,
            width: constraints.maxWidth * percentage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                colors: <Color> [
                  Palettes.primary.value,
                  Palettes.accent.value,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}