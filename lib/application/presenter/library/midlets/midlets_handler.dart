import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/game_entity.dart';
import '../../../core/entities/midlet_entity.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/enumerations/views_enumerations.dart';
import '../../../core/extensions/router_extension.dart';

import '../../../repositories/bucket_repository.dart';
import '../../../services/admob_service.dart';

import '../../widgets/advertisement_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/thumbnail_widget.dart';

part '../midlets/components/list_view_component.dart';
part '../midlets/components/midlet_tile_component.dart';
part '../midlets/components/midlets_counter_component.dart';

part '../midlets/midlets_controller.dart';
part '../midlets/midlets_view.dart';

class MIDlets extends StatefulWidget {

  final Game game;

  const MIDlets(this.game, {super.key});

  @override
  State<MIDlets> createState() => _MIDletsState();
}

class _MIDletsState extends State<MIDlets> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final BucketRepository rBucket;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the MIDlets handler...");

    rBucket = Provider.of<BucketRepository>(
      context,
      listen: false,
    );
    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );

    controller = _Controller(
      game: widget.game,
      rBucket: rBucket,
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
    Logger.trash("Disposing the MIDlets resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MIDletsView(
    controller: controller,
    localizations: localizations,
  );
}