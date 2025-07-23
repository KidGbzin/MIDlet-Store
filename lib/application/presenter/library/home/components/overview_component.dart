part of '../home_handler.dart';

class _Overview extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _Overview(this.controller);

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Palettes.foreground.value,
      padding: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
      child: SizedBox(
        height: 102,
        child: AsyncBuilder(
          future: widget.controller.getGlobalStats(),
          onSuccess: (BuildContext context, ({int downloads, int games, int midlets, int reviews}) snapshot) {
            return body(
              downloads: snapshot.downloads,
              games: snapshot.games,
              midlets: snapshot.midlets,
              reviews: snapshot.reviews,
            );
          }
        ),
      ),
    );
  }

  Widget body({
    required int games,
    required int midlets,
    required int reviews,
    required int downloads,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 7.5,
      children: <Widget> [
        Expanded(
          child: InkWell(
            borderRadius: gBorderRadius,
            onTap: () => context.gtSearch(),
            child: label(
              icon: HugeIcons.strokeRoundedGameController03,
              title: "Games", // TODO: Translate
              value: games.toString(),
            ),
          ),
        ),
        Expanded(
          child: label(
            icon: HugeIcons.strokeRoundedJava,
            title: "MIDlets",
            value: midlets.toString(),
          ),
        ),
        Expanded(
          child: label(
            icon: HugeIcons.strokeRoundedStar,
            title: "Reviews",
            value: reviews.toString(),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: gAnimationDuration,
            child: label(
              icon: HugeIcons.strokeRoundedDownload01,
              title: l10n.lbDownloads,
              value: downloads.toString(),
            ),
          ),
        ),
      ],
    );
  }

  Widget label({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
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