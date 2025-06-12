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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: () => context.pop(),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.nState,
        builder: (BuildContext context, ProgressEnumeration state, Widget? _) {
          if (state == ProgressEnumeration.isReady) {
            return _ListView(
              controller: controller,
            );
          }
          else if (state == ProgressEnumeration.isLoading) {
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