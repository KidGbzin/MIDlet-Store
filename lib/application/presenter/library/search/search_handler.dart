import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/game_data_entity.dart';
import '../../../core/entities/game_entity.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/tag_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/messenger_extension.dart';
import '../../../core/extensions/router_extension.dart';

import '../../../repositories/bucket_repository.dart';
import '../../../repositories/supabase_repository.dart';
import '../../../repositories/hive_repository.dart';

import '../../../services/admob_service.dart';

import '../../widgets/advertisement_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/loading_widget.dart';
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

// SEARCH HANDLER 🔍: =========================================================================================================================================================== //

/// The application's search view.
///
/// This view provides users with a comprehensive list of all games, featuring a search bar and filtering options to enhance navigation and discovery.
/// It integrates with external services for data retrieval and caching.
class Search extends StatefulWidget {

  /// The publisher to filter by.
  /// 
  /// If provided, the search view will display only games from the specified publisher.
  final String? publisher;

  const Search({
    this.publisher,
    super.key,
  });

  @override
  State<Search> createState() => _SearchViewState();
}

class _SearchViewState extends State<Search> {
  late final _Controller controller;
  
  late final BucketRepository rBucket;
  late final HiveRepository rHive;
  late final SupabaseRepository rSupabase;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Update handler...");

    rBucket = Provider.of<BucketRepository>(
      context,
      listen: false,
    );
    rSupabase = Provider.of<SupabaseRepository>(
      context,
      listen: false,
    );
    rHive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );
    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );

    controller = _Controller(
      rBucket: rBucket,
      rSupabase: rSupabase,
      rHive: rHive,
      sAdMob: sAdMob,
    );
    controller.initialize(
      publisher: widget.publisher,
    );
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Update resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SearchView(controller);
}