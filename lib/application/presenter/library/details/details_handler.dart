import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image/image.dart' as image;

import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../core/configuration/global_configuration.dart';
import '../../../core/entities/game_data_entity.dart';
import '../../../core/entities/game_entity.dart';
import '../../../core/entities/midlet_entity.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/messenger_extension.dart';
import '../../../core/extensions/router_extension.dart';

import '../../../repositories/bucket_repository.dart';
import '../../../repositories/hive_repository.dart';
import '../../../repositories/supabase_repository.dart';

import '../../../services/activity_service.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/modal_widget.dart';
import '../../widgets/rating_stars_widget.dart';
import '../../widgets/section_widget.dart';
import '../../widgets/thumbnail_widget.dart';

part '../details/components/about_section_component.dart';
part '../details/components/bookmark_button_component.dart';
part '../details/components/cover_section_component.dart';
part '../details/components/dialog_components.dart';
part '../details/components/installation_modal_component.dart';
part '../details/components/installation_section_component.dart';
part '../details/components/modal_components.dart';
part '../details/components/overview_section_component.dart';
part '../details/components/previews_section_component.dart';
part '../details/components/related_section_component.dart';

part '../details/views/details_view.dart';

part '../details/details_controller.dart';

// DETAILS HANDLER 🔧: ========================================================================================================================================================== //

/// The details view of a specific game.
///
/// This view displays detailed information about a selected game and provides functionality for interacting with its data.
/// It integrates with external services for retrieving and managing game-related content.
class Details extends StatefulWidget {
  
  const Details(this.game, {super.key});

  /// The game to display details for.
  final Game game;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final _Controller controller;

  late final ActivityService activity;
  late final BucketRepository bucket;
  late final HiveRepository hive;
  late final SupabaseRepository database;

  @override
  void initState() {
    activity = Provider.of<ActivityService>(
      context,
      listen: false,
    );
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
      sActivity: activity,
      rBucket: bucket,
      game: widget.game,
      rHive: hive,
      rDatabase: database,
    );
    controller.initialize();
  
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DetailsView(controller);
}