part of '../details_handler.dart';

class _SubmitRatingModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SubmitRatingModal({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_SubmitRatingModal> createState() => _SubmitRatingModalState();
}

class _SubmitRatingModalState extends State<_SubmitRatingModal> {
  late final ValueNotifier<num> _currentRating;

  bool _isReadyToSubmit(num currentRating) => (currentRating != 0 && currentRating != widget.controller.myRatingState.value);

  @override
  void initState() {
    _currentRating = ValueNotifier<num>(widget.controller.myRatingState.value);

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          _buildRatingSection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Section(
      description: widget.controller.myRatingState.value == 0
        ? widget.localizations.sectionUserRatingDescriptionNotRated
        : widget.localizations.sectionUserRatingDescriptionRated,
      
      title: widget.localizations.sectionUserRating,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        child: Align(
          alignment: Alignment.center,
          child: ValueListenableBuilder<int>(
            valueListenable: widget.controller.myRatingState,
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
                    widget.controller.myRatingState.value == 0
                      ? widget.localizations.buttonSubmitRating
                      : widget.localizations.buttonUpdateRating,
                    
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
}