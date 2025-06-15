part of '../details_handler.dart';

class _TopReviewsSection extends StatefulWidget {

  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _TopReviewsSection({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_TopReviewsSection> createState() => _TopReviewsSectionState();
}

class _TopReviewsSectionState extends State<_TopReviewsSection> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.getTop3Reviews(),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
        Widget child;

        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            child = SizedBox.shrink();
          }
          else {
            child = reviews(snapshot.data!);
          }
        }
        else if (snapshot.hasError) {
          Logger.error(
            snapshot.error.toString(),
            stackTrace: snapshot.stackTrace,
          );
          
          child = SizedBox.shrink();
        }
        else {
          child = Padding(
            padding: const EdgeInsets.all(25),
            child: LoadingAnimation(),
          );
        }
        return AnimatedSwitcher(
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          duration: Durations.extralong4,
          child: child,
        );
      },
    );
  }

  Widget reviews(List<Review> reviews) {
    final List<Widget> children = <Widget> [];

    for (final Review review in reviews) {
      children.add(__TopReviewTile(
        controller: widget.controller,
        localizations: widget.localizations,
        review: review,
      ));
    }

    return InkWell(
      onTap: () => context.gtReviews(widget.controller.game),
      child: Column(
        children: children,
      ),
    );
  }
}

class __TopReviewTile extends StatelessWidget {

  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  final Review review;

  const __TopReviewTile({
    required this.controller,
    required this.localizations,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 7.5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              spacing: 7.5,
              runSpacing: 7.5,
              children: <Widget> [
                Text(
                  "${review.flag} • ${review.userName.toUpperCase()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                ),
                Text(
                  review.fRelativeDate(review.locale),
                  style: TypographyEnumeration.body(Palettes.grey).style,
                ),
              ],
            ),
            RatingStarsWidget(
              rating: review.rating.toDouble(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
              child: Text(
                review.fBody(localizations),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.elements).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}