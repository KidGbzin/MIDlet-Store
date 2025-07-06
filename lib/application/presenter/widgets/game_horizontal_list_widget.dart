import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/presenter/widgets/button_widget.dart';

import '../../core/configuration/global_configuration.dart';
import '../../core/entities/game_entity.dart';

import '../../core/extensions/router_extension.dart';

import '../../core/enumerations/palette_enumeration.dart';
import '../../core/enumerations/typographies_enumeration.dart';

import '../widgets/async_builder_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/section_widget.dart';

// MARK: -------------------------
// 
// 
// 
// MARK: Widget ⮟

class GameHorizontalList extends StatefulWidget {

  final Future<double> Function(Game) fetchRating;

  final Future<File?> Function(Game) fetchThumbnail;

  final Future<List<Game>> collection;

  /// The section'a description.
  final String description;

  /// The section's title.
  final String title;

  const GameHorizontalList({
    required this.collection,
    required this.description,
    required this.fetchRating,
    required this.fetchThumbnail,
    required this.title,
    super.key, 
  });

  @override
  State<GameHorizontalList> createState() => _GameHorizontalListState();
}

class _GameHorizontalListState extends State<GameHorizontalList> {
  late final double tileWidth = (MediaQuery.sizeOf(context).width - 60) / 3;
  late final Size thumbnailSize;

  final double titleHeight = 29;
  final double ratingHeight = 20;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    thumbnailSize = getThumbnailSize();
  }

  Size getThumbnailSize() {
    final double width = (MediaQuery.sizeOf(context).width - 60) / 3;
    final double height = width / 0.75;

    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: widget.description,
      title: widget.title,
      child: Container(
        height: thumbnailSize.height + titleHeight + ratingHeight,
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: AsyncBuilder(
          future: widget.collection,
          onSuccess: (BuildContext context, List<Game> games) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (index == games.length) {
                  return ButtonWidget.icon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    onTap: () => context.gtSearch(),
                  );
                }
            
                return _Tile(
                  game: games[index],
                  fetchRating: widget.fetchRating,
                  fetchThumbnail: widget.fetchThumbnail,
                  width: tileWidth,
                );
              },
              itemCount: games.length + 1,
              separatorBuilder: (BuildContext context, int index) {
                return VerticalDivider(
                  width: 15,
                  color: Palettes.transparent.value,
                );
              },
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              scrollDirection: Axis.horizontal,
            );
          },
        ),
      ),
    );
  }
}

// MARK: -------------------------
// 
// 
// 
// MARK: Tile ⮟

class _Tile extends StatefulWidget {

  final double width;

  final Game game;

  final Future<double> Function(Game) fetchRating;

  final Future<File?> Function(Game) fetchThumbnail;

  const _Tile({
    required this.game,
    required this.fetchRating,
    required this.fetchThumbnail,
    required this.width,
  });

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: AsyncBuilder(
        future: fetch(widget.game),
        onSuccess: (BuildContext context, ({double rating, File? thumbnail}) snapshot) {
          return body(
            rating: snapshot.rating,
            thumbnail: snapshot.thumbnail,
          );
        },
        onLoading: body(
          rating: 0,
          thumbnail: null,
          isLoading: true,
        ),
      ),
    );
  }

  Future<({double rating, File? thumbnail})> fetch(Game game) async {
    final double rating = await widget.fetchRating(game);
    final File? thumbnail = await widget.fetchThumbnail(game);

    return (
      rating: rating,
      thumbnail: thumbnail,
    );
  }

  Widget body({
    required double rating,
    required File? thumbnail,
    bool isLoading = false,
  }) {
    Widget? placeholder;
    DecorationImage? decoration;

    if (thumbnail != null) {
      decoration = DecorationImage(
        image: FileImage(thumbnail),
      );
    }
    else {
      placeholder = Icon(
        HugeIcons.strokeRoundedImage02,
        color: Palettes.grey.value,
      );
    }

    return Column(
      children: <Widget> [
        AspectRatio(
          aspectRatio: 0.75,
          child: InkWell(
            borderRadius: gBorderRadius,
            onTap: () => context.gtDetails(
              game: widget.game,
            ),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: gBorderRadius,
                boxShadow: isLoading ? null : kElevationToShadow[3],
                image: decoration,
              ),
              child: isLoading ? const LoadingAnimation() : placeholder,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            widget.game.fTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(Palettes.elements).style,
            textAlign: TextAlign.center,
          ),
        ),
        RatingStarsWidget(
          rating: rating,
        ),
      ],
    );
  }
}