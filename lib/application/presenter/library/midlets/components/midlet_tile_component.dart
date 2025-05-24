part of '../midlets_handler.dart';

class _ListTile extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  const _ListTile({
    required this.controller,
    required this.localizations,
    required this.midlet,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.gtInstallation(midlet);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
            child: Text(
              midlet.title.replaceFirst(' -', ':').toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                _wLeading(),
                Expanded(
                  child: _wDetails(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
            child: Text(
              "See details and start playing — just tap!", // TODO: Translate.
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.body(ColorEnumeration.grey).style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wLeading() {
    final List<Widget> icons = <Widget> [];

    if (midlet.isThreeD) icons.add(_wIconLabel(HugeIcons.strokeRoundedCodesandbox));
    if (midlet.isLandscape) icons.add(_wIconLabel(HugeIcons.strokeRoundedSmartPhoneLandscape));
    if (midlet.isMultiplayerB) icons.add(_wIconLabel(HugeIcons.strokeRoundedBluetooth));
    if (midlet.isMultiplayerL) icons.add(_wIconLabel(HugeIcons.strokeRoundedUserMultiple));
    if (midlet.isOnline) icons.add(_wIconLabel(HugeIcons.strokeRoundedCellularNetwork));
    if (midlet.isCensored) icons.add(_wIconLabel(HugeIcons.strokeRoundedUnavailable));

    if (icons.isEmpty) icons.add(_wIconLabel(HugeIcons.strokeRoundedDashedLine01));

    return Column(
      spacing: 7.5,
      children: <Widget> [
        SizedBox(
          height: 142.5,
          child: AspectRatio(
            aspectRatio: 0.75,
            child: ThumbnailWidget(
              image: FileImage(controller.cover),
            ),
          ),
        ),
        Row(
          spacing: 2.55,
          children: icons,
        ),
      ],
    );
  }

  Widget _wDetails() {
    // TODO> Translate.
    String multiscreen = "";
    String touchscreen = "Keyboard";

    if (midlet.isMultiscreen) multiscreen = " & Multiscreen";
    if (midlet.isTouchscreen) touchscreen = "Touchscreen";

    final List<Widget> children = <Widget> [
      _wInformationLabel(HugeIcons.strokeRoundedModernTv, " Resolution: ${midlet.resolution.replaceAll("x", " x ")}$multiscreen"),
      _wInformationLabel(HugeIcons.strokeRoundedPackage, " Size: ${(midlet.size / 1024).round()} KB"),
      _wInformationLabel(HugeIcons.strokeRoundedGlobe02, " ${midlet.languages.reduce((x, y) => "$x • $y")}"),
      _wInformationLabel(HugeIcons.strokeRoundedSmartPhone01, " Phone: ${midlet.brand}"),
      _wInformationLabel(HugeIcons.strokeRoundedTouch01, " $touchscreen"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 7.5,
      children: children,
    );
  }

  Widget _wIconLabel(IconData icon) {
    return Icon(
      icon,
      size: 18,
      color: ColorEnumeration.grey.value,
    );
  }

  Widget _wInformationLabel(IconData icon, String text) {
    return Row(
      children: <Widget> [
        HugeIcon(
          icon: icon,
          color: ColorEnumeration.grey.value,
          size: 18,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ),
      ],
    );
  }
}