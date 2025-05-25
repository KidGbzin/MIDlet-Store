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
    _DetailsSection(widget.midlet),
    gDivider,
    AdvertisementWidget(getAdvertisement: widget.controller.sAdMob.getAdvertisement),
    gDivider,
    _SelectEmulatorSection(
      controller: widget.controller,
      localizations: widget.localizations,
    ),
    gDivider,
    AdvertisementWidget(getAdvertisement: widget.controller.sAdMob.getAdvertisement),
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
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget> [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ColorEnumeration.background.value,
            surfaceTintColor: ColorEnumeration.background.value,
            pinned: true,
            titleSpacing: 0,
            flexibleSpace: _HeaderSection(widget.controller, widget.localizations),
            toolbarHeight: 102,
            expandedHeight: 102,
            collapsedHeight: 102,
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