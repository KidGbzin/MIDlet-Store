part of '../details_handler.dart';

class _PlayButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _PlayButton({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  late final MIDlet? midlet;

  @override
  void initState() {
    super.initState();

    midlet = widget.controller.game.midlets
      .cast<MIDlet?>()
      .firstWhere((element) => element!.isDefault);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorEnumeration.transparent.value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        child: InkWell(
          borderRadius: gBorderRadius,
          onTap: () {
            if (midlet != null) {
              context.gtInstallation(midlet!);
            }
            else {
              Logger.error("There's no default MIDlet, redirecting to the MIDlets view...");

              context.gtMIDlets(
                cover: widget.controller.thumbnailState.value!,
                midlets: widget.controller.game.midlets,
              );
            }
          },
          child: Ink(
            height: 45,
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[3],
              borderRadius: gBorderRadius,
              gradient: LinearGradient(
                colors: <Color> [
                  ColorEnumeration.primary.value,
                  ColorEnumeration.accent.value,
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              spacing: 7.5,
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Text(
                    "PLAY GAME", // TODO: Translate.
                    style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
                  ),
                ),
                Icon(
                  HugeIcons.strokeRoundedPlay,
                  size: 25,
                  color: ColorEnumeration.elements.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}