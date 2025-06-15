part of '../installation/installation_handler.dart';

class _InstallationView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

   /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  const _InstallationView({
    required this.controller,
    required this.localizations,
    required this.midlet,
  });

  @override
  State<_InstallationView> createState() => _InstallationViewState();
}

class _InstallationViewState extends State<_InstallationView> {
  late final List<Widget> children = <Widget> [
    _ActionsSection(widget.midlet),
    gDivider,
    Advertisement.banner(widget.controller.getAdvertisement("0")),
    gDivider,
    _DetailsSection(
      localizations: widget.localizations,
      midlet: widget.midlet,
    ),
    gDivider,
    Advertisement.banner(widget.controller.getAdvertisement("1")),
    gDivider,
    _SelectEmulatorSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
    gDivider,
    Advertisement.banner(widget.controller.getAdvertisement("2")),
    gDivider,
    _InstallButton(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          spacing: 7.5,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            const Spacer(),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedLink02,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext _) => _SourceModal(widget.controller, widget.localizations),
                );
              }
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palettes.background.value,
            surfaceTintColor: Palettes.background.value,
            pinned: true,
            titleSpacing: 0,
            flexibleSpace: _HeaderSection(widget.controller, widget.localizations),
            toolbarHeight: 102,
            expandedHeight: 102,
            collapsedHeight: 102,
          ),
          ValueListenableBuilder(
            valueListenable: widget.controller.nProgress,
            builder: (BuildContext context, (Progresses, Object?) progress, Widget? _) {
              if (progress.$1 == Progresses.isReady) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => children[index],
                    childCount: children.length,
                  ),
                );
              }
              else if (progress.$1 == Progresses.isLoading) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: LoadingAnimation(),
                  ),
                );
              }
              else if (progress.$1 == Progresses.hasError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ErrorMessage(progress.$2!),
                  ),
                );
              }
              else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ErrorMessage(Exception),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}