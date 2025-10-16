part of '../search_filters/search_filters_handler.dart';

class _View extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller cHandler;

  const _View(this.cHandler);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            spacing: 7.5,
            children: <Widget> [
              ButtonWidget.icon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                onTap: context.pop,
              ),
              SizedBox.square(
                dimension: 40,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                child: Text(
                  "FILTERS", // TODO: Translate.
                  style: TypographyEnumeration.headline(Palettes.elements).style,
                ),
              ),
              const Spacer(),
              ButtonWidget.icon(
                icon: HugeIcons.strokeRoundedFilterRemove,
                onTap: widget.cHandler.clear,
              ),
              ButtonWidget.icon(
                icon: HugeIcons.strokeRoundedTick02,
                onTap: () {
                  widget.cHandler.apply();
                  context.pop();
                },
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget> [
            _Categories(widget.cHandler),
            gDivider,
            _Year(widget.cHandler),
            gDivider,
            _Publisher(widget.cHandler),
          ],
        ),
      ),
    );
  }
}
