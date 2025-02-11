part of '../details_handler.dart';

class _DetailsView extends StatefulWidget {

  const _DetailsView({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView> with WidgetsBindingObserver {
  late ScaffoldMessengerState snackbar;
  late final String gameTitle;
  late final AppLocalizations localizations;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    gameTitle = widget.controller.game.title.replaceFirst(' -', ':');

    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    snackbar = ScaffoldMessenger.of(context);
    snackbar.clearSnackBars();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    snackbar.clearSnackBars();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            const Spacer(),
            _BookmarkButton(
              controller: widget.controller,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: <Widget> [
          _Cover(
            controller: widget.controller,
          ),
          _divider(),
          _OverviewSection(
            controller: widget.controller,
          ),
          _divider(),
          _About(
            description: widget.controller.game.description(Localizations.localeOf(context)),
          ),
          _divider(),
          _InstallationSection(
            controller: widget.controller,
          ),
          _divider(),
          _PreviewsSection(
            controller: widget.controller,
          ),
          _divider(),
          _RelatedGamesSection(
            collection: widget.controller.getTopPublisherGames(),
            controller: widget.controller,
            description: localizations.sectionPublisherDescription.replaceFirst('_', widget.controller.game.publisher),
            title: widget.controller.game.publisher,
          ),
          _divider(),
          _RelatedGamesSection(
            collection: widget.controller.getTopRelatedGames(),
            controller: widget.controller,
            description: localizations.sectionRelatedGamesDescription.replaceFirst('_', gameTitle),
            title: localizations.sectionRelatedGames,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: ColorEnumeration.divider.value,
      height: 1,
      thickness: 1,
    );
  }
}