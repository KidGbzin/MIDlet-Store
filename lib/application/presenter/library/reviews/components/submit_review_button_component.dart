part of '../reviews_handler.dart';

class _SubmitReviewButton extends StatefulWidget {

  /// Called when the submit button is tapped.
  ///
  /// Triggered only if the review is considered complete (rating, difficulty, and playthrough time are all set).
  final void Function() onSubmitReview;

  /// The current review state notifier.
  ///
  /// Used to dynamically update the button's appearance based on the review's values.
  final ValueNotifier<Review> nReview;

  const _SubmitReviewButton({
    required this.nReview,
    required this.onSubmitReview,
  });

  @override
  State<_SubmitReviewButton> createState() => _SubmitReviewButtonState();
}

class _SubmitReviewButtonState extends State<_SubmitReviewButton> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.nReview,
      builder: (BuildContext context, Review review, Widget? child) {
        final bool isReadyToSubmit = review.rating != 0 && review.difficulty != 0 && review.playthroughTime != 0;

        return AnimatedSwitcher(
          duration: gAnimationDuration,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: GradientButton(
            key: Key(isReadyToSubmit.toString()),
            icon: isReadyToSubmit ? HugeIcons.strokeRoundedSent02 : HugeIcons.strokeRoundedEdit01,
            onTap: () {
              if (isReadyToSubmit) widget.onSubmitReview();
            },
            primaryColor: isReadyToSubmit ? Palettes.primary : Palettes.foreground,
            secondaryColor: isReadyToSubmit ? Palettes.accent : Palettes.foreground,
            text: isReadyToSubmit ? l10n.btSubmitRating : l10n.btUpdateYourRating,
          ),
        );
      }
    );
  }
}