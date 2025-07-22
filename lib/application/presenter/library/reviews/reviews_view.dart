part of '../reviews/reviews_handler.dart';

class _View extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _View(this.controller);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _FloatingButton(widget.controller),
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
                l10n.hdReviews,
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
            SizedBox.square(
              dimension: 40,
            ),
          ],
        ),
      ),
      body: _ReviewsList(widget.controller),
    );
  }
}