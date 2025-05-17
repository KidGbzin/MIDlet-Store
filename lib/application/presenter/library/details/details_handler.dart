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

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/game_data_entity.dart';
import '../../../core/entities/game_entity.dart';
import '../../../core/entities/midlet_entity.dart';

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

part '../details/details_controller.dart';
part '../details/details_view.dart';

class Details extends StatefulWidget {

  /// The [Game] object representing the game whose details will be displayed.
  final Game game;
  
  const Details(this.game, {super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final ActivityService sActivity;
  late final BucketRepository rBucket;
  late final HiveRepository rHive;
  late final SupabaseRepository rSupabase;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Details handler...");

    sActivity = Provider.of<ActivityService>(
      context,
      listen: false,
    );
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
    
    controller = _Controller(
      game: widget.game,
      sActivity: sActivity,
      rBucket: rBucket,
      rHive: rHive,
      rSupabase: rSupabase,
    );
    controller.initialize();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Details resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _DetailsView(
    controller: controller,
    localizations: localizations,
  );
}