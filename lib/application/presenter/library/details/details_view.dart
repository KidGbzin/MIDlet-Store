part of '../details/details_handler.dart';

class _DetailsView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _DetailsView({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView> with WidgetsBindingObserver {
  late final String gameTitle;

  late ScaffoldMessengerState snackbar;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    gameTitle = widget.controller.game.title.replaceFirst(' -', ':');

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.controller.resumeAudio(); // If the application returns to resume state, then resume de music player.
    }
    else {
      widget.controller.pauseAudio(); // If the application is not in the main view, then stops the music player.
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
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
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
                else {
                  context.gtSearch();
                }
              },
            ),
            const Spacer(),
            _BookmarkButton(widget.controller),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: <Widget> [
          _CoverSection(widget.controller),
          gDivider,
          _OverviewSection(widget.controller),
          gDivider,
          _About(
            description: widget.controller.game.description(Localizations.localeOf(context)),
          ),
          gDivider,
          _InstallationSection(
            controller: widget.controller,
          ),
          gDivider,
          _PreviewsSection(
            controller: widget.controller,
          ),
          gDivider,
          _RelatedGamesSection(
            collection: widget.controller.getTopPublisherGames(),
            controller: widget.controller,
            description: widget.localizations.sectionPublisherDescription.replaceFirst('\$1', widget.controller.game.publisher),
            title: widget.controller.game.publisher,
          ),
          gDivider,
          _RelatedGamesSection(
            collection: widget.controller.getTopRelatedGames(),
            controller: widget.controller,
            description: widget.localizations.sectionRelatedGamesDescription.replaceFirst('\$1', gameTitle),
            title: widget.localizations.sectionRelatedGames,
          ),
        ],
      ),
    );
  }
}