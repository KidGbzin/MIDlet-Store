part of '../details_handler.dart';

/// Creates a [Widget] that shows the game MIDlets install section.
class _Install extends StatelessWidget {

  const _Install({
    required this.controller,
  });

  /// The [Details] controller.
  /// 
  /// The controller that handles the state and installation of the MIDlets.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return Section(
      description: "This game has a total of ${controller.game.midlets.length} MIDlets. Select your version and press play. Once the download is finished, it will be installed on the emulator directly.\n\n"
        "Not sure which version to choose?\n"
        "Simply press play, and we'll install the best version for you.",
      title: 'MIDlets',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget> [
            Expanded(
              child: Button.withTitle(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Modals.midlets(
                        installMIDlet: controller.installMIDlet,
                        midlets: controller.game.midlets,
                      );
                    }
                  );
                },
                icon: Icons.code_rounded,
                title: "MIDlets",
              ),
            ),
            VerticalDivider(
              color: Palette.transparent.color,
              width: 25,
            ),
            Expanded(
              child: Button.withTitle(
                filled: true,
                icon: Icons.download_rounded,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialogs.installMIDlet(
                        installMIDlet: controller.installMIDlet(controller.game.main),
                      );
                    }
                  );
                },
                title: "Play Game",
              ),
            ),
          ],
        ),
      ),
    );
  }
}