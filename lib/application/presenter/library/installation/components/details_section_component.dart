part of '../installation_handler.dart';

class _DetailsSection extends StatefulWidget {

  final MIDlet midlet;

  final AppLocalizations localizations;

  const _DetailsSection({
    required this.localizations,
    required this.midlet,
  });

  @override
  State<_DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<_DetailsSection> {
  late final AppLocalizations localizations = widget.localizations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          child: details(),
        ),
        gDivider,
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          child: languages(),
        ),
      ],
    );
  }

  Widget info(IconData icon, String description) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        borderRadius: gBorderRadius,
        color: Palettes.foreground.value,
      ),
      width: (MediaQuery.sizeOf(context).width - 45) / 3,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: Palettes.elements.value,
            size: 18,
          ),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(Palettes.elements).style,
          ),
        ],
      )
    );
  }

  Widget languages() {
    final List<Widget> language = [];

    for (final String code in widget.midlet.languages) {
      final Language? flag = Language.fromCode(code);

      if (flag != null) {
        language.add(Container(
          height: 75,
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: Palettes.foreground.value,
          ),
          width: (MediaQuery.sizeOf(context).width - 45) / 3,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 7.5,
            children: <Widget> [
              SizedBox.square(
                dimension: 18,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(flag.asset),
                ),
              ),
              Text(
                flag.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TypographyEnumeration.body(Palettes.elements).style,
              ),
            ],
          ),
        ));
      }
    }

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 7.5,
      runSpacing: 7.5,
      children: language,
    );
  }

  Widget details() {
    final List<Widget> children = <Widget> [];

    if (widget.midlet.isLandscape) children.add(information(HugeIcons.strokeRoundedSmartPhoneLandscape, localizations.lbLandscape));
    if (!widget.midlet.isLandscape) children.add(information(HugeIcons.strokeRoundedSmartPhone01, localizations.lbPortrait));
    if (widget.midlet.isThreeD) children.add(information(HugeIcons.strokeRoundedCodesandbox, localizations.lb3D));
    if (widget.midlet.isMultiplayerB) children.add(information(HugeIcons.strokeRoundedBluetooth, localizations.lbMultiplayerBluetooth));
    if (widget.midlet.isMultiplayerL) children.add(information(HugeIcons.strokeRoundedUserMultiple, localizations.lbMultiplayerLocal));
    if (widget.midlet.isOnline) children.add(information(HugeIcons.strokeRoundedCellularNetwork, "Online"));
    if (widget.midlet.isCensored) children.add(information(HugeIcons.strokeRoundedUnavailable, localizations.lbCensored));
    
    return Column(
      spacing: 7.5,
      children: children,
    );
  }

  Widget information(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 7.5,
      children: <Widget> [
        Icon(
          icon,
          color: Palettes.grey.value,
          size: 18,
        ),
        Expanded(
          child: Text(
            text,
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {

  final MIDlet midlet;

  const _ActionsSection(this.midlet);

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Palettes.foreground.value,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          Expanded(
            child: button(midlet.fResolution, HugeIcons.strokeRoundedModernTv),
          ),
          Expanded(
            child: button(midlet.fSize, HugeIcons.strokeRoundedPackage),
          ),
          Expanded(
            child: button("Keyboard", HugeIcons.strokeRoundedVideoConsole),
          ),
          Expanded(
            child: button(midlet.brand, HugeIcons.strokeRoundedSmartPhone01),
          ),
        ],
      ),
    );
  }

  Widget button(String action, IconData icon) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: gBorderRadius,
        color: Palettes.foreground.value,
      ),
      padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 15),
      child: Column(
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: Palettes.grey.value,
            size: 25,
          ),
          Text(
            action,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ],
      ),
    );
  }
}