import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../globals.dart';

import '../../../core/entities/game_data_entity.dart';
import '../../../core/entities/game_entity.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/tag_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/messenger_extension.dart';

import '../../../repositories/bucket_repository.dart';
import '../../../repositories/database_repository.dart';
import '../../../repositories/hive_repository.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/modal_widget.dart';
import '../../widgets/rating_stars_widget.dart';
import '../../widgets/section_widget.dart';
import '../../widgets/thumbnail_widget.dart';

part '../search/components/filter_button_component.dart';
part '../search/components/list_view_component.dart';
part '../search/components/modal_categories_component.dart';
part '../search/components/modal_publisher_component.dart';
part '../search/components/modal_release_component.dart';
part '../search/components/search_bar_component.dart';
part '../search/components/suggestion_overlay_component.dart';

part '../search/views/search_view.dart';

part '../search/search_controller.dart';

// SEARCH HANDLER 🧩: =========================================================================================================================================================== //

/// The application's search view.
///
/// This view provides users with a comprehensive list of all games, featuring a search bar and filtering options to enhance navigation and discovery.
/// It integrates with external services for data retrieval and caching.
class Search extends StatefulWidget {

  const Search({
    this.publisher,
    super.key,
  });

  final String? publisher;

  @override
  State<Search> createState() => _SearchViewState();
}

class _SearchViewState extends State<Search> {
  late final _Controller controller;
  
  late final BucketRepository bucket;
  late final HiveRepository hive;
  late final SupabaseRepository database;

  @override
  void initState() {
    bucket = Provider.of<BucketRepository>(
      context,
      listen: false,
    );
    database = Provider.of<SupabaseRepository>(
      context,
      listen: false,
    );
    hive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );

    controller = _Controller(
      bucket: bucket,
      database: database,
      hive: hive,
    );
    controller.initialize(
      publisher: widget.publisher,
    );
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _SearchView(controller);
}