part of '../details_handler.dart';

/// A section widget displaying the game overview, including the release date, publisher logo, and average rating.
///
/// This widget consists of three main sections: release information, publisher details, and the average rating.
/// Each section is clickable, with the rating section triggering a modal for submitting ratings.
class _OverviewSection extends StatefulWidget {

  const _OverviewSection({
    required this.controller,
  });

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
        children: <Widget>[
          Expanded(
            child: _buildReleaseLabel(),
          ),
          VerticalDivider(
            width: 31,
            thickness: 1,
            color: ColorEnumeration.divider.value,
          ),
          Expanded(
            child: _buildPublisherLabel(),
          ),
          VerticalDivider(
            width: 31,
            thickness: 1,
            color: ColorEnumeration.divider.value,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.averageRating,
              builder: (BuildContext context, double averageRating, Widget? _) {
                return _buildRatingLabel(averageRating);
              },
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
  Widget _buildPublisherLabel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Expanded(
          child: Image.asset(
            'assets/publishers/${widget.controller.game.publisher}.png',
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              Logger.error.print(
                label: 'Details | Overview\'s Publisher Image',
                message: '$error',
                stackTrace: stackTrace,
              );
              return Icon(
                Icons.broken_image_rounded,
                color: ColorEnumeration.grey.value,
              );
            },
          ),
        ),
        Container(
          height: 38,
          margin: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
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
    );
  }

  /// Displays the average rating for the game and allows users to tap to submit a new rating.
  ///
  /// The rating is shown as a number, and a star-based visual rating is displayed below.
  /// Tapping on the rating triggers a modal where users can submit a new rating for the game.
  Widget _buildRatingLabel(double averageRating) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
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