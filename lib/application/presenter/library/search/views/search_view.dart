part of '../search_handler.dart';

class _SearchView extends StatefulWidget {

  const _SearchView({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_SearchView> createState() => __SearchState();
}

class __SearchState extends State<_SearchView> {
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
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
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
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedFilter,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _FilterModal(
                      applyFilters: widget.controller.applyFilters,
                      clearFilters: widget.controller.clearFilters,
                      publisherState: widget.controller.publisherState,
                      tagsState: widget.controller.tagsState,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.controller.currentlyActiveGameList,
        builder: (BuildContext context, List<Game> listenable, Widget? _) {
          return _ListView(
            controller: widget.controller,
            games: listenable,
          );
        }
      ),
    );
  }
}