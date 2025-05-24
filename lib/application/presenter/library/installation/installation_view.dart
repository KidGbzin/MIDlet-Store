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
    _DetailsSection(widget.midlet),
    gDivider,
    AdvertisementWidget(getAdvertisement: widget.controller.sAdMob.getAdvertisement),
    gDivider,
    install(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            const Spacer(),
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
            flexibleSpace: Section(
              description: "Please check the MIDlet information before installing.",
              title: widget.midlet.title.replaceFirst(" -", ":"),
            ),
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

  Widget install() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: ButtonWidget.widget(
        width: double.infinity,
        onTap: () {},
        color: ColorEnumeration.primary.value,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "INSTALL MIDLET", // TODO: Translate.
            style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
          ),
        ),
      ),
    );
  }
}