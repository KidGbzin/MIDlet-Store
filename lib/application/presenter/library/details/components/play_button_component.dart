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
        child: Ink(
          decoration: BoxDecoration(
            boxShadow: kElevationToShadow[3],
          ),
          child: GradientButton(
            icon: HugeIcons.strokeRoundedPlay,
            onTap: () {
              if (midlet != null) {
                context.gtInstallation(
                  game: widget.controller.game,
                  midlet: midlet!,
                );
              }
              else {
                Logger.error("There's no default MIDlet, redirecting to the MIDlets view...");
          
                context.gtMIDlets(
                  cover: widget.controller.thumbnailState.value!,
                  midlets: widget.controller.game.midlets,
                );
              }
            },
            text: "PLAY GAME", // TODO: Translate
            width: (MediaQuery.sizeOf(context).width - 45) / 2,
          ),
        ),
      ),
    );
  }
}