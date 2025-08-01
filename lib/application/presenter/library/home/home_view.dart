part of '../home/home_handler.dart';

class _View extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _View(this.controller);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedProfile02,
              onTap: () => context.gtProfile(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                "MIDLET STORE",
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedSearch02,
              onTap: () => context.gtSearch(),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget> [
          _Overview(widget.controller),
          // TODO: Translate.
          GameHorizontalList(
            collection: widget.controller.getLatestGames(),
            description: "Discover the latest games added or improved in our collection.",
            fetchThumbnail: widget.controller.fetchThumbnail,
            title: "Recently Updated Games",
          ),
          gDivider,
          GameHorizontalList(
            collection: widget.controller.getTop10RatedGames(),
            description: "Check out the most loved games in our archive.",
            fetchThumbnail: widget.controller.fetchThumbnail,
            title: "TOP RATED GAMES",
          ),
          gDivider,
        ],
      ),
    );
  }
}