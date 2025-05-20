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
  State<_DetailsView> createState() => __DetailsViewState();
}

class __DetailsViewState extends State<_DetailsView> {
  late final List<Widget> children = <Widget> [
    _RatingSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
    gDivider,
    _ActionsSection(widget.localizations),    
    gDivider,
    _About(
      description: widget.controller.game.description(Localizations.localeOf(context)),
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
      description: widget.localizations.sectionRelatedGamesDescription.replaceFirst('\$1', widget.controller.game.title.replaceFirst(' -', ':')),
      title: widget.localizations.sectionRelatedGames,
    ),
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _PlayButton(
        controller: widget.controller,
        localizations: widget.localizations,
      ),
      body: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorEnumeration.background.value,
            surfaceTintColor: ColorEnumeration.background.value,
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
            expandedHeight: (MediaQuery.sizeOf(context).width / 0.75) - MediaQuery.of(context).padding.top,
            flexibleSpace: FlexibleSpaceBar(
              background: _CoverSection(widget.controller),
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorEnumeration.background.value,
            surfaceTintColor: ColorEnumeration.background.value,
            pinned: true,
            titleSpacing: 0,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(widget.controller),
              ],
            ),
            toolbarHeight: 60.6,
            expandedHeight: 60.6,
            collapsedHeight: 60.6,
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