part of '../reviews_handler.dart';

class _SubmitReviewButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SubmitReviewButton({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_SubmitReviewButton> createState() => _SubmitReviewButtonState();
}

class _SubmitReviewButtonState extends State<_SubmitReviewButton> {
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palettes.transparent.value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: Ink(
          decoration: BoxDecoration(
            boxShadow: kElevationToShadow[3],
          ),
          child: GradientButton(
            icon: HugeIcons.strokeRoundedStar,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) => _SubmitReviewModal(
                  controller: widget.controller,
                  localizations: widget.localizations
                ),
              );
            },
            text: widget.localizations.btSubmitReview,
            width: (MediaQuery.sizeOf(context).width - 45) / 2,
          ),
        ),
      ),
    );
  }
}