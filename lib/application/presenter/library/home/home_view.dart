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
            SizedBox.square(
              dimension: 40,
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
          // TODO: Translate.
          GameHorizontalList(
            collection: widget.controller.getLatestGames(),
            description: "Estes são os jogos atualizados recentemente.",
            fetchRating: widget.controller.fetchAverageRating,
            fetchThumbnail: widget.controller.fetchThumbnail,
            title: "ATUALIZADOS RECENTEMENTE",
          ),
        ],
      ),
    );
  }
}