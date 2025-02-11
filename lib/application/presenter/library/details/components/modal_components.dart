part of '../details_handler.dart';

class _SubmitRatingModal extends StatefulWidget {

  const _SubmitRatingModal({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_SubmitRatingModal> createState() => _SubmitRatingModalState();
}

class _SubmitRatingModalState extends State<_SubmitRatingModal> {
  late final ValueNotifier<num> _currentRating;

  bool _isReadyToSubmit(num currentRating) => (currentRating != 0 && currentRating != widget.controller.myRating.value);

  @override
  void initState() {
    _currentRating = ValueNotifier<num>(widget.controller.myRating.value);

    super.initState();
  }

  @override
  void dispose() {
    _currentRating.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: context.pop,
        ),
      ],
      child: ListView(
        children: <Widget> [
          Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: _buildLeadingRatingInformation(widget.controller.totalRatings.value),
                ),
                Expanded(
                  child: _buildRatingBarsGraph(),
                ),
              ],
            ),
          ),
          Divider(
            color: ColorEnumeration.divider.value,
            height: 1,
            thickness: 1,
          ),
          _buildRatingSection(),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Section(
      description: widget.controller.myRating.value == 0
        ? AppLocalizations.of(context)!.sectionUserRatingDescriptionNotRated
        : AppLocalizations.of(context)!.sectionUserRatingDescriptionRated,
      
      title: AppLocalizations.of(context)!.sectionUserRating,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        child: Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder<int>(
            valueListenable: widget.controller.myRating,
            builder: (BuildContext context, int userRating, Widget? _) {
              return RatingBar(
                initialRating: userRating.toDouble(),
                itemSize: 50,
                glow: false,
                onRatingUpdate: (double rating) {
                  _currentRating.value = rating;
                },
                ratingWidget: RatingWidget(
                  full: Icon(
                    HugeIcons.strokeRoundedStar,
                    color: ColorEnumeration.gold.value,
                  ),
                  half: Icon(
                    HugeIcons.strokeRoundedStarHalf,
                    color: ColorEnumeration.gold.value,
                  ),
                  empty: Icon(
                    HugeIcons.strokeRoundedStar,
                    color: ColorEnumeration.disabled.value,
                  ),
                )
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ValueListenableBuilder(
      valueListenable: _currentRating,
      builder: (BuildContext context, num currentRating, Widget? _) {
        final bool isReadyToSubmit = _isReadyToSubmit(currentRating);

        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.5),
            onTap: () {
              if (isReadyToSubmit) {
                widget.controller.upsertUserRating(currentRating.toInt());
                context.pop();
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
                gradient: LinearGradient(
                  colors: <Color> [
                    isReadyToSubmit ? ColorEnumeration.primary.value : ColorEnumeration.foreground.value,
                    isReadyToSubmit ? ColorEnumeration.accent.value : ColorEnumeration.foreground.value,
                  ],
                ),
              ),
              height: 45,
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                  child: Text(
                    widget.controller.myRating.value == 0
                      ? AppLocalizations.of(context)!.buttonSubmitRating
                      : AppLocalizations.of(context)!.buttonUpdateRating,
                    
                    style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the leading rating information for the widget.
  ///
  /// This widget shows the average rating of the game along with a star rating widget and the total number of ratings.
  /// If the average rating is zero, it displays a dash (`-`).
  Widget _buildLeadingRatingInformation(int total) {
    final double averageRating = widget.controller.averageRating.value;

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
          '${widget.controller.totalRatings.value}',
          style: TypographyEnumeration.body(ColorEnumeration.grey).style,
        ),
      ],
    );
  }

  /// Builds the graph displaying the rating distribution as bars.
  ///
  /// This method listens for changes in the stars count and updates the graph accordingly.
  Widget _buildRatingBarsGraph() {
    return ValueListenableBuilder(
      valueListenable: widget.controller.starsCount,
      builder: (BuildContext context, Map<String, int> starsCount, Widget? _) {
        return Column(
          children: <Widget> [
            for (int index = 5; index >= 1; index --) _buildStarTileBar(index, starsCount["$index"]!),
          ],
        );
      },
    );
  }

  /// Builds a single rating bar for the given star value.
  ///
  /// The [stars] value represents the star rating (1-5), and [count] is the number of votes for that rating.
  /// The bar width represents the percentage of votes for that rating.
  Widget _buildStarTileBar(int stars, int count) {
    final double percentage = widget.controller.totalRatings.value > 0
      ? count / widget.controller.totalRatings.value
      : 0;

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
                padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                child: Stack(
                  children: <Widget> [
                    _buildBackgroundStarTile(),
                    _buildForegroundStarTile(constraints.maxWidth, percentage),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the background of the rating bar.
  ///
  /// This is a solid background bar for each rating, with a consistent color.
  Widget _buildBackgroundStarTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: ColorEnumeration.foreground.value,
      ),
      height: 10,
    );
  }

  /// Builds the foreground of the rating bar showing the percentage.
  ///
  /// The width of the foreground bar is calculated based on the percentage of ratings for the corresponding star value.
  Widget _buildForegroundStarTile(double maxWidth, double percentage) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 10,
        width: maxWidth * percentage,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            colors: <Color>[
              ColorEnumeration.primary.value,
              ColorEnumeration.accent.value,
            ],
          ),
        ),
      ),
    );
  }
}