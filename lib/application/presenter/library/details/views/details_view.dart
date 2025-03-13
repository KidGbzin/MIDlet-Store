part of '../details_handler.dart';

// DETAILS VIEW 🧩: ============================================================================================================================================================= //

/// The main view for the game details page.
/// 
/// This view displays detailed information about a specific game, including its cover, title, description, and additional data.
class _DetailsView extends StatefulWidget {

  const _DetailsView(this.controller);

  /// The controller for the game details page.
  final _Controller controller;

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView> with WidgetsBindingObserver {
  late final String gameTitle;
  late final AppLocalizations localizations;

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
            _BookmarkButton(widget.controller),
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
            description: localizations.sectionPublisherDescription.replaceFirst('\$1', widget.controller.game.publisher),
            title: widget.controller.game.publisher,
          ),
          gDivider,
          _RelatedGamesSection(
            collection: widget.controller.getTopRelatedGames(),
            controller: widget.controller,
            description: localizations.sectionRelatedGamesDescription.replaceFirst('\$1', gameTitle),
            title: localizations.sectionRelatedGames,
          ),
        ],
      ),
    );
  }
}