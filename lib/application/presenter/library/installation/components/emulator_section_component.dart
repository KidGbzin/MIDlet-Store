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
      title: widget.localizations.scSelectEmulator,
      description: widget.localizations.scSelectEmulatorDescription,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Row(
          spacing: 15,
          children: <Widget> [
            Expanded(
              child: _EmulatorTile(
                controller: widget.controller,
                emulator: Emulators.j2meLoader,
              ),
            ),
            Expanded(
              child: _EmulatorTile(
                controller: widget.controller,
                emulator: Emulators.jlMod,
              ),
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
                color: Palettes.divider.value,
                width: 1,
              ),
              borderRadius: gBorderRadius,
              color: emulator == selectedEmulator ? emulator.primaryColor : Palettes.background.value,
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
                  style: TypographyEnumeration.body(Palettes.elements).style,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}