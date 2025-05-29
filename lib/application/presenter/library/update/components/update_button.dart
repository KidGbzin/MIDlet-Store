part of '../update_handler.dart';

class _UpdateButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _UpdateButton({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_UpdateButton> createState() => __UpdateButtonState();
}

class __UpdateButtonState extends State<_UpdateButton> {

  @override
  Widget build(BuildContext context) {
    return ButtonWidget.widget(
      color: Palettes.foreground.value,
      onTap: () {
        widget.controller.openMIDletStoreReleases();
      },
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
          child: Text(
            widget.localizations.buttonUpdateAvailable.toUpperCase(),
            maxLines: 1,
            style: TypographyEnumeration.headline(Palettes.elements).style,
          ),
        ),
      ),
    );
  }
}