part of '../details_handler.dart';

// OVERVIEW SECTION 📄: ========================================================================================================================================================= //

/// A section widget displaying the game overview, including the release date, publisher logo, and average rating.
///
/// This widget consists of three main sections: release information, publisher details, and the average rating.
/// Each section is clickable, with the rating section triggering a modal for submitting ratings.
class _OverviewSection extends StatefulWidget {

  const _OverviewSection(this.controller);

  /// The controller that manages the game data.
  final _Controller controller;

  @override
  State<_OverviewSection> createState() => _OverviewSectionState();
}

class _OverviewSectionState extends State<_OverviewSection> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        spacing: 30,
        children: <Widget> [
          Expanded(
            child: _buildReleaseLabel(),
          ),
          Expanded(
            child: _buildPublisherLabel(),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.averageRatingState,
              builder: (BuildContext context, double averageRating, Widget? _) =>_buildRatingLabel(averageRating),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the release date of the game.
  Widget _buildReleaseLabel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Text(
          AppLocalizations.of(context)!.labelRelease,
          style: TypographyEnumeration.body(ColorEnumeration.elements).style,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            widget.controller.game.release.toString(),
            style: TypographyEnumeration.rating(ColorEnumeration.elements).style,
          ),
        ),
      ],
    );
  }

  /// Displays the publisher information for the game.
  ///
  /// This section includes the publisher's logo (as an asset) and the publisher's name.
  /// When tapped, it navigates to the search page with the publisher's name as a search query.
  Widget _buildPublisherLabel() {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        context.showSearch(
          publisher: widget.controller.game.publisher,
          replace: false,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          Expanded(
            child: _buildLogo(),
          ),
          Ink(
            height: 38,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.controller.game.publisher,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(ColorEnumeration.elements).style,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return FutureBuilder(
      future: widget.controller.publisherLogo,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!,
            filterQuality: FilterQuality.high,
          );
        }
        return Align(
          alignment: Alignment.center,
          child: LoadingAnimation(),
        );
      }
    );
  }

  /// Displays the average rating for the game and allows users to tap to submit a new rating.
  ///
  /// The rating is shown as a number, and a star-based visual rating is displayed below.
  /// Tapping on the rating triggers a modal where users can submit a new rating for the game.
  Widget _buildRatingLabel(double averageRating) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return _SubmitRatingModal(
              controller: widget.controller,
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text(
            averageRating == 0 ? '-' : '$averageRating',
            style: TypographyEnumeration.rating(ColorEnumeration.elements).style,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
            child: RatingStarsWidget(
              rating: averageRating,
              starSize: 17.5,
            ),
          ),
        ],
      ),
    );
  }
}