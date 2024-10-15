part of '../home_handler.dart';

class _HomeView extends StatefulWidget {

  const _HomeView({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late List<Tag> categories;

  @override
  void initState() {
    categories = widget.controller.getRandomTags(5);
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            const Spacer(),
            Button(
              icon: Icons.search_rounded,
              onTap: () => context.push('/search'),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _Category(
            controller: widget.controller,
            games: widget.controller.getGamesFromCategory(categories[index].name),
            tag: categories[index],
          );
        },
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Palette.divider.color,
            height: 1,
            thickness: 1,
          );
        },
      ),
    );
  }
}