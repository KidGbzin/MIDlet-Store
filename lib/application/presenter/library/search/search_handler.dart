import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/entities/game_entity.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../external/services/github_service.dart';

import '../../../source/interfaces/bucket_interface.dart';
import '../../../source/interfaces/database_interface.dart';

import '../../shared/factories/buttons_factory.dart';
import '../../shared/factories/modals/modals_factory.dart';
import '../../shared/widgets/handler_widget.dart';
import '../../shared/widgets/rating_widget.dart';
import '../../shared/widgets/tags_widget.dart';
import '../../shared/widgets/thumbnail_widget.dart';

part '../search/components/game_lister_component.dart';
part '../search/components/game_tile_component.dart';
part '../search/components/search_bar_component.dart';
part 'components/suggestion_overlay_component.dart';
part 'components/suggestion_tile_component.dart';

part '../search/views/search_view.dart';

part '../search/search_controller.dart';

class Search extends StatefulWidget {

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late _Controller controller;
  late IBucket bucket;
  late IDatabase database;

  @override
  void initState() {
    bucket = Provider.of<IBucket>(
      context,
      listen: false,
    );
    database = Provider.of<IDatabase>(
      context,
      listen: false,
    );
    controller = _Controller(
      bucket: bucket,
      database: database,
    )..initialize();

  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Handler(
      message: ValueNotifier(''),
      progress: controller.progress,
      child: _Search(
        controller: controller,
      ),
    );
  }
}