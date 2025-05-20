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
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          builder: (BuildContext context) {
            return _SubmitRatingModal(
              controller: widget.controller,
              localizations: widget.localizations,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: Ink(
          height: 100,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: _wLeadingScore(widget.controller.totalRatingsState.value),
              ),
              Expanded(
                child: _wRatingBarsGraph(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wLeadingScore(int total) {
    final double averageRating = widget.controller.averageRatingState.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Text(
          averageRating == 0 ? '-' : '$averageRating',
          style: TypographyEnumeration.rating(ColorEnumeration.elements).style,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
          child: RatingStarsWidget(
            rating: averageRating,
            starSize: 17.5,
          ),
        ),
        Text(
          '${widget.controller.totalRatingsState.value}',
          style: TypographyEnumeration.body(ColorEnumeration.grey).style,
        ),
      ],
    );
  }

  Widget _wRatingBarsGraph() {
    return ValueListenableBuilder(
      valueListenable: widget.controller.starsCountState,
      builder: (BuildContext context, Map<String, int> starsCount, Widget? _) {
        final int totalRatings = (starsCount["5"]! + starsCount["4"]! + starsCount["3"]! + starsCount["2"]! + starsCount["1"]!);
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            for (int index = 5; index >= 1; index --) _wStarTile(
              stars: index,
              starRatingCount: starsCount["$index"]!,
              totalRatingsCount: totalRatings,
            ),
          ],
        );
      },
    );
  }

  Widget _wStarTile({
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
                    _wBackgroundStarTile(),
                    _wForegroundStarTile(percentage),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _wBackgroundStarTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: ColorEnumeration.foreground.value,
      ),
      height: 10,
    );
  }

  Widget _wForegroundStarTile(double percentage) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 10,
            width: constraints.maxWidth * percentage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                colors: <Color> [
                  ColorEnumeration.primary.value,
                  ColorEnumeration.accent.value,
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}