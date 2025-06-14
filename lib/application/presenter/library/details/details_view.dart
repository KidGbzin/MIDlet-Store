part of '../details/details_handler.dart';

class _View extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _View({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late final double padding = MediaQuery.of(context).padding.top;

  late final List<Widget> children = <Widget> [
    _RatingSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
    gDivider,
    _ActionsSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),    
    gDivider,
    _About(
      description: widget.controller.game.fDescription(Localizations.localeOf(context)),
      localizations: widget.localizations,
    ),
    gDivider,
    _PreviewsSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
    gDivider,
    _RelatedGamesSection(
      collection: widget.controller.getTopPublisherGames(),
      controller: widget.controller,
      description: widget.localizations.scRelatedPublisherDescription.replaceFirst("@publisher", widget.controller.game.publisher),
      title: widget.controller.game.publisher,
    ),
    gDivider,
    _RelatedGamesSection(
      collection: widget.controller.getTopRelatedGames(),
      controller: widget.controller,
      description: widget.localizations.scRelatedGamesDescription.replaceFirst("@title", widget.controller.game.fTitle),
      title: widget.localizations.scRelatedGames,
    ),
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _PlayButton(
        controller: widget.controller,
        localizations: widget.localizations,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: gFABPadding,
      body: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palettes.background.value,
            surfaceTintColor: Palettes.background.value,
            pinned: true,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 7.5,
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
              ],
            ),
            expandedHeight: (MediaQuery.sizeOf(context).width / 0.75) - padding,
            flexibleSpace: FlexibleSpaceBar(
              background: _CoverSection(widget.controller),
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palettes.background.value,
            collapsedHeight: 102 - padding,
            expandedHeight: 102 - padding,
            flexibleSpace: _HeaderSection(widget.controller),
            pinned: true,
            surfaceTintColor: Palettes.background.value,
            titleSpacing: 0,
            toolbarHeight: 102 - padding,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => children[index],
              childCount: children.length,
            ),
          ),
        ],
      ),
    );
  }
}