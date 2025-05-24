part of '../installation_handler.dart';

class _DetailsSection extends StatefulWidget {

  final MIDlet midlet;

  const _DetailsSection(this.midlet);

  @override
  State<_DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<_DetailsSection> {

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
        color: ColorEnumeration.foreground.value,
      ),
      width: (MediaQuery.sizeOf(context).width - 45) / 3,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: ColorEnumeration.elements.value,
            size: 18,
          ),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(ColorEnumeration.elements).style,
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
            color: ColorEnumeration.foreground.value,
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
                style: TypographyEnumeration.body(ColorEnumeration.elements).style,
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
    // TODO: Translate.

    final List<Widget> children = <Widget> [];

    if (widget.midlet.isLandscape) children.add(information(HugeIcons.strokeRoundedSmartPhoneLandscape, "Landscape"));
    if (!widget.midlet.isLandscape) children.add(information(HugeIcons.strokeRoundedSmartPhone01, "Portrait"));
    if (widget.midlet.isThreeD) children.add(information(HugeIcons.strokeRoundedCodesandbox, "3D Engine"));
    if (widget.midlet.isMultiplayerB) children.add(information(HugeIcons.strokeRoundedBluetooth, "Bluetooth Multiplayer"));
    if (widget.midlet.isMultiplayerL) children.add(information(HugeIcons.strokeRoundedUserMultiple, "Multiplayer Local"));
    if (widget.midlet.isOnline) children.add(information(HugeIcons.strokeRoundedCellularNetwork, "Online"));
    if (widget.midlet.isCensored) children.add(information(HugeIcons.strokeRoundedUnavailable, "Censored"));
    
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
          color: ColorEnumeration.grey.value,
          size: 18,
        ),
        Expanded(
          child: Text(
            text,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
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
      color: ColorEnumeration.foreground.value,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          //TODO: Translate this section.
          //TODO: Convert to action buttons.
          Expanded(
            child: button(midlet.formattedResolution, HugeIcons.strokeRoundedModernTv),
          ),
          Expanded(
            child: button(midlet.formattedSize, HugeIcons.strokeRoundedPackage),
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
        color: ColorEnumeration.foreground.value,
      ),
      padding: EdgeInsets.fromLTRB(7.5, 15, 7.5, 15),
      child: Column(
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: ColorEnumeration.grey.value,
            size: 25,
          ),
          Text(
            action,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ],
      ),
    );
  }
}