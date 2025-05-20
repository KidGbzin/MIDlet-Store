part of '../details_handler.dart';

class _PlayButton extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _PlayButton({
    required this.controller,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorEnumeration.transparent.value,
      child: InkWell(
        borderRadius: gBorderRadius,
        onTap: () {
          // TODO:  Add action to the download view.
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
    );
  }
}