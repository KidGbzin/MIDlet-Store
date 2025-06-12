part of '../details_handler.dart';

class _ActionsSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _ActionsSection({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_ActionsSection> createState() => __ActionsSectionState();
}

class __ActionsSectionState extends State<_ActionsSection> {
  late final List<MIDlet> midlets = widget.controller.game.midlets;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Palettes.foreground.value,
      padding: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          Expanded(
            child: InkWell(
              borderRadius: gBorderRadius,
              onTap: () {
                context.gtMIDlets(widget.controller.game);
              },
              child: label(
                icon: HugeIcons.strokeRoundedJava,
                title: "MIDlets",
                value: midlets.length.toString(),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.nGameMetadata,
              builder: (BuildContext context, GameMetadata? metadata, Widget? _) {
                final String downloads = (metadata?.downloads ?? "-").toString();

                return AnimatedSwitcher(
                  duration: gAnimationDuration,
                  child: label(
                    key: ValueKey(downloads),
                    icon: HugeIcons.strokeRoundedDownload01,
                    title: widget.localizations.lbDownloads,
                    value: downloads,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget label({
    Key? key,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 12.5),
      child: Column(
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: Palettes.elements.value,
            size: 25,
          ),
          Text(
            "$title\n$value",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(Palettes.grey).style,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}