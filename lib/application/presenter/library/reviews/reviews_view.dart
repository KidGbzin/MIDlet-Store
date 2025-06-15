part of '../reviews/reviews_handler.dart';

class _View extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _View({
    required this.controller,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _SubmitReviewButton(
        controller: controller,
        localizations: localizations,
      ),
      floatingActionButtonLocation: gFABPadding,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                localizations.hdReviews,
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
            SizedBox.square(
              dimension: 40,
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.nState,
        builder: (BuildContext context, Progresses state, Widget? _) {
          if (state == Progresses.isReady) {
            return _ListView(
              controller: controller,
              localizations: localizations,
            );
          }
          else if (state == Progresses.isLoading) {
            return Center(child: LoadingAnimation());
          }
          else {
            return SizedBox();
          }
        },
      ),
    );
  }
}