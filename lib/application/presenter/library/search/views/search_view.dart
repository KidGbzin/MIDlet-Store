part of '../search_handler.dart';

class _Search extends StatefulWidget {

  const _Search({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_Search> createState() => __SearchState();
}

class __SearchState extends State<_Search> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            Visibility.maintain(
              visible: false,
              child: Button(
                icon: Icons.arrow_back_rounded,
                onTap: context.pop,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: _SearchBar(
                  controller: widget.controller,
                ),
              ),
            ),
            Visibility.maintain(
              visible: false,
              child: Button(
                icon: Icons.filter_alt_rounded,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.controller.games,
        builder: (BuildContext context, List<Game> listenable, Widget? _) {
          return _GameLister(
            controller: widget.controller,
            games: listenable,
          );
        }
      ),
    );
  }
}