part of '../details_handler.dart';

class _RatingSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _RatingSection(this.controller);

  @override
  State<_RatingSection> createState() => __RatingSectionState();
}

class __RatingSectionState extends State<_RatingSection> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fetchRatingDistribution(),
      builder: (BuildContext context, AsyncSnapshot<({double average, (int, int, int, int, int) ratings, int total})> snapshot) {
        Widget leading = SizedBox.shrink();
        bool isReady = false;
        double average = 0;
        (int, int, int, int, int) ratings = (0, 0, 0, 0, 0);
        int total = 0;
    
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            ratings = snapshot.data!.ratings;
            average = snapshot.data!.average;
            total = snapshot.data!.total;

            leading = score(average, total);
          }
          else {
            Logger.error(
              snapshot.error.toString(),
              stackTrace: snapshot.stackTrace,
            );

            leading = error();
          }

          isReady = true;
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          leading = loading();
        }
        else {
          Logger.error(
            "Unhandled state: ${snapshot.connectionState}!",
            stackTrace: snapshot.stackTrace,
          );

          leading = error();
        }
        return InkWell(
          onTap: () {
            if (isReady) context.gtReviews(widget.controller.game);
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
                      child: leading,
                    ),
                  ),
                  Expanded(
                    child: body(total, ratings),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loading() {
    return SizedBox.square(
      key: Key("Loading"),
      dimension: 95,
      child: LoadingAnimation(),
    );
  }

  Widget error() {
    return SizedBox.square(
      key: Key("Error"),
      dimension: 95,
      child: Icon(
        HugeIcons.strokeRoundedBug01,
        color: Palettes.grey.value,
      ),
    );
  }

  Widget score(double rating, int total) {
    return SizedBox(
      key: Key("Leading-Score"),
      width: 95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: <Widget> [
          Text(
            rating == 0 ? '-' : '$rating',
            style: TypographyEnumeration.rating(Palettes.elements).style,
          ),
          RatingStarsWidget(
            rating: rating,
            starSize: 17.5,
          ),
          Text(
            '$total',
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ],
      ),
    );
  }

  Widget body(int total, (int, int, int, int, int) ratings) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget> [
        tile(5, ratings.$5, total),
        tile(4, ratings.$4, total),
        tile(3, ratings.$3, total),
        tile(2, ratings.$2, total),
        tile(1, ratings.$1, total),
      ],
    );
  }

  Widget tile(int stars, int count, int total) {
    final double percentage = total == 0 ? 0 : count / total;

    Widget background = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Palettes.foreground.value,
      ),
      height: 10,
    );

    Widget foreground = LayoutBuilder(
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
                  children: <Widget> [background, foreground],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}