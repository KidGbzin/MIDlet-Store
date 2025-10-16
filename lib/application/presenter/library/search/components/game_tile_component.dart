part of '../search_handler.dart';

class _GameTile extends StatefulWidget {

  const _GameTile({
    required this.controller,
    required this.game,
  });

  final _Controller controller;

  final Game game;

  @override
  State<_GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<_GameTile> {
  late final AppLocalizations l10n = AppLocalizations.of(context)!;
  late final Locale locale = Localizations.localeOf(context);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.gtDetails(
        game: widget.game,
      ),
      child: FutureBuilder(
        future: Future.wait([
          widget.controller.getThumbnail(widget.game.title),
          widget.controller.getGameMetadata(widget.game),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          double averageRating = 0.0;
          File? cover;
          int downloads = 0;

          if (snapshot.hasData) {
            averageRating = snapshot.data![1].averageRating;
            cover = snapshot.data![0];
            downloads = snapshot.data![1].downloads;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 25, 15, 0), // The headline font is misaligned by a single pixel.
                child: Row(
                  children: <Widget> [
                    Expanded(
                      child: Text(
                        widget.game.fTitle.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TypographyEnumeration.headline(Palettes.elements).style,
                      ),
                    ),
                    Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      color: Palettes.elements.value,
                      size: gIconSmall,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
                child: Text(
                  Category.fromList(l10n, widget.game.tags).reduce((x, y) => "$x • $y"),
                  style: TypographyEnumeration.body(Palettes.grey).style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget> [
                    coverAndRating(cover, averageRating),
                    Expanded(
                      child: details(downloads),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Text(
                  widget.game.fDescription(locale) ?? "",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TypographyEnumeration.body(Palettes.grey).style,
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget coverAndRating(File? cover, double averageRating) {
    late final Widget thumbnail;

    if (cover != null) {
      thumbnail = ThumbnailWidget(
        image: FileImage(cover),
      );
    }

    else {
      thumbnail = HugeIcon(
        icon: HugeIcons.strokeRoundedImage01,
        color: Palettes.grey.value,
        size: 18,
      );
    }
    return Column(
      spacing: 7.5,
      children: <Widget> [
        SizedBox(
          height: 142.5,
          child: AspectRatio(
            aspectRatio: 0.75,
            child: thumbnail,
          ),
        ),
        RatingStarsWidget(
          rating: averageRating,
        ),
      ],
    );
  }

  Widget details(int downloads) {

    Widget label(IconData icon, String text) {
      return Row(
        spacing: 5,
        children: <Widget> [
          Icon(
            icon,
            color: Palettes.grey.value,
            size: 18,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyEnumeration.body(Palettes.grey).style,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 7.5,
      children: <Widget> [
        label(HugeIcons.strokeRoundedCorporate, "${l10n.lbPublisher}: ${widget.game.publisher}"),
        label(HugeIcons.strokeRoundedCalendar01, "${l10n.lbRelease}: ${widget.game.release}"),
        label(HugeIcons.strokeRoundedJava, "MIDlets: ${widget.game.midlets.length}"),
        label(HugeIcons.strokeRoundedDownload01, "${l10n.lbDownloads}: $downloads"),
        label(HugeIcons.strokeRoundedStar, "Reviews: 0"),
      ],
    );
  }
}