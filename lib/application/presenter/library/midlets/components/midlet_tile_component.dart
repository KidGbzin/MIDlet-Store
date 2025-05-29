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
        context.gtInstallation(
          game: controller.game,
          midlet: midlet,
        );
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
              style: TypographyEnumeration.headline(Palettes.elements).style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                leading(),
                Expanded(
                  child: details(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
            child: Text(
              "",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.body(Palettes.grey).style,
            ),
          ),
        ],
      ),
    );
  }

  Widget leading() {
    final List<Widget> icons = <Widget> [];

    if (midlet.isThreeD) icons.add(iconLabel(HugeIcons.strokeRoundedCodesandbox));
    if (midlet.isLandscape) icons.add(iconLabel(HugeIcons.strokeRoundedSmartPhoneLandscape));
    if (midlet.isMultiplayerB) icons.add(iconLabel(HugeIcons.strokeRoundedBluetooth));
    if (midlet.isMultiplayerL) icons.add(iconLabel(HugeIcons.strokeRoundedUserMultiple));
    if (midlet.isOnline) icons.add(iconLabel(HugeIcons.strokeRoundedCellularNetwork));
    if (midlet.isCensored) icons.add(iconLabel(HugeIcons.strokeRoundedUnavailable));

    if (icons.isEmpty) icons.add(iconLabel(HugeIcons.strokeRoundedDashedLine01));

    return Column(
      spacing: 7.5,
      children: <Widget> [
        SizedBox(
          height: 142.5,
          child: AspectRatio(
            aspectRatio: 0.75,
            child: ValueListenableBuilder(
              valueListenable: controller.nThumbnail,
              builder: (BuildContext context, File? thumbnail, Widget? _) {
                if (thumbnail == null) {
                  return Icon(
                    HugeIcons.strokeRoundedImage02,
                    color: Palettes.grey.value,
                    size: 18,
                  );
                }
                return ThumbnailWidget(
                  image: FileImage(thumbnail),
                );
              }
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

  Widget details() {
    String multiscreen = "";
    String touchscreen = "Keyboard";

    if (midlet.isMultiscreen) multiscreen = " & ${localizations.lbMultiscreen}";
    if (midlet.isTouchscreen) touchscreen = localizations.lbTouchscreen;

    final List<Widget> children = <Widget> [
      informationLabel(HugeIcons.strokeRoundedModernTv, " ${midlet.resolution.replaceAll("x", " x ")}$multiscreen"),
      informationLabel(HugeIcons.strokeRoundedPackage, " ${localizations.lbSize}: ${(midlet.size / 1024).round()} KB"),
      informationLabel(HugeIcons.strokeRoundedGlobe02, " ${midlet.languages.reduce((x, y) => "$x • $y")}"),
      informationLabel(HugeIcons.strokeRoundedSmartPhone01, " ${midlet.brand}"),
      informationLabel(HugeIcons.strokeRoundedTouch01, " $touchscreen"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 7.5,
      children: children,
    );
  }

  Widget iconLabel(IconData icon) {
    return Icon(
      icon,
      size: 18,
      color: Palettes.grey.value,
    );
  }

  Widget informationLabel(IconData icon, String text) {
    return Row(
      children: <Widget> [
        HugeIcon(
          icon: icon,
          color: Palettes.grey.value,
          size: 18,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ),
      ],
    );
  }
}