import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/game_metadata_entity.dart';
import '../../../core/entities/game_entity.dart';
import '../../../core/entities/midlet_entity.dart';

import '../../../core/enumerations/emulators_enumeration.dart';
import '../../../core/enumerations/language_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../repositories/bucket_repository.dart';

import '../../../repositories/hive_repository.dart';
import '../../../repositories/supabase_repository.dart';
import '../../../services/activity_service.dart';
import '../../../services/admob_service.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/gradient_button_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/modal_widget.dart';
import '../../widgets/section_widget.dart';

part '../installation/components/details_section_component.dart';
part '../installation/components/emulator_section_component.dart';
part '../installation/components/emulator_tile_component.dart';
part '../installation/components/header_section_component.dart';
part '../installation/components/install_button_component.dart';
part '../installation/components/install_modal_component.dart';
part '../installation/components/source_modal_component.dart';

part '../installation/installation_controller.dart';
part '../installation/installation_view.dart';

class Installation extends StatefulWidget {

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  const Installation({
    required this.game,
    required this.midlet,
    super.key,
  });

  @override
  State<Installation> createState() => _InstallationState();
}

class _InstallationState extends State<Installation> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final BucketRepository rBucket;
  late final HiveRepository rHive;
  late final SupabaseRepository rSupabase;
  late final ActivityService sActivity;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Installation handler of \"${widget.midlet.file}\"...");

    rBucket = Provider.of<BucketRepository>(
      context,
      listen: false,
    );
    rHive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );
    rSupabase = Provider.of<SupabaseRepository>(
      context,
      listen: false,
    );
    sActivity = Provider.of<ActivityService>(
      context,
      listen: false,
    );
    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );

    controller = _Controller(
      game: widget.game,
      midlet: widget.midlet,
      rBucket: rBucket,
      rHive: rHive,
      rSupabase: rSupabase,
      sActivity: sActivity,
      sAdMob: sAdMob,
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
    Logger.trash("Disposing the Installation resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InstallationView(
    controller: controller,
    localizations: localizations,
    midlet: widget.midlet,
  );
}