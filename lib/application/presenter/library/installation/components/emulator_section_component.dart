part of '../installation_handler.dart';

class _SelectEmulatorSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SelectEmulatorSection({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_SelectEmulatorSection> createState() => _SelectEmulatorSectionState();
}

class _SelectEmulatorSectionState extends State<_SelectEmulatorSection> {

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "SELECT EMULATOR", // TODO: Translate.
      description: "Please select which emulator you'd like to install.",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Row(
          spacing: 15,
          children: <Widget> [
            Expanded(
              child: emulator(Emulators.j2meLoader),
            ),
            Expanded(
              child: emulator(Emulators.jlMod),
            ),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedHelpCircle,
              onTap: () {
                // TODO: Create a help modal.
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget emulator(Emulators emulator) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        widget.controller.nEmulator.value = emulator;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.nEmulator,
        builder: (BuildContext context, Emulators selectedEmulator, Widget? _) {
          return Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorEnumeration.divider.value,
                width: 1,
              ),
              borderRadius: gBorderRadius,
              color: emulator == selectedEmulator ? emulator.primaryColor : ColorEnumeration.background.value,
            ),
            height: 100,
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              spacing: 7.5,
              children: <Widget> [
                Expanded(
                  child: Image.asset(emulator.assetImage),
                ),
                Text(
                  emulator.title,
                  style: TypographyEnumeration.body(ColorEnumeration.elements).style,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}