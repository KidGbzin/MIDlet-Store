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
  late ScaffoldMessengerState snackbar;

  @override
  void didChangeDependencies() {
    snackbar = ScaffoldMessenger.of(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    snackbar.clearSnackBars();

    super.dispose();
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
            Button(
              icon: Icons.arrow_back_rounded,
              onTap: context.pop,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: _SearchBar(
                  controller: widget.controller,
                ),
              ),
            ),
            Button(
              icon: Icons.filter_alt_rounded,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Modals.filter(
                      publisherState: widget.controller.publisherState,
                      tagsState: widget.controller.tagsState,
                      applyFilters: widget.controller.applyFilters,
                      clearFilters: widget.controller.clearFilters,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.controller.gamesState,
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