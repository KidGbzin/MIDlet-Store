part of '../reviews_handler.dart';

class _FloatingButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _FloatingButton(this.controller);

  @override
  State<_FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<_FloatingButton> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;
  
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
                isScrollControlled: false,
                builder: (BuildContext context) => _SubmitReviewModal(widget.controller),
              );
            },
            text: l10n.btSubmitReview,
            width: (MediaQuery.sizeOf(context).width - 45) / 2,
          ),
        ),
      ),
    );
  }
}