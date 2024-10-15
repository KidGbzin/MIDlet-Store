part of '../home_handler.dart';

class _Category extends StatefulWidget {

  const _Category({
    required this.controller,
    required this.games,
    required this.tag,
  });

  final _Controller controller;
  final List<Game> games;
  final Tag tag;

  @override
  State<_Category> createState() => _CategoryState();
}

class _CategoryState extends State<_Category> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Section(
      description: widget.tag.description,
      title: widget.tag.name,
      child: Container(
        height: (MediaQuery.sizeOf(context).width - 60) / 3 / 0.75,
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return AspectRatio(
              aspectRatio: 0.75,
              child: _Cover(
                controller: widget.controller,
                title: widget.games[index].title,
              ),
            );
          },
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          itemCount: widget.games.length > 10 ? 10 : widget.games.length,
          separatorBuilder: (BuildContext context, int index) {
            return VerticalDivider(
              color: Palette.transparent.color,
              width: 15,
            );
          },
        ),
      ),
    );
  }
}