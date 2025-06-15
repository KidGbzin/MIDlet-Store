import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/core/enumerations/views_enumerations.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/game_entity.dart';
import '../../../core/entities/game_metadata_entity.dart';
import '../../../core/entities/review_entity.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../repositories/hive_repository.dart';
import '../../../repositories/supabase_repository.dart';

import '../../../services/admob_service.dart';

import '../../widgets/advertisement_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/confetti_widget.dart';
import '../../widgets/gradient_button_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/modal_widget.dart';
import '../../widgets/rating_stars_widget.dart';
import '../../widgets/section_widget.dart';

part '../reviews/components/list_view_component.dart';
part '../reviews/components/review_tile_component.dart';
part '../reviews/components/score_component.dart';
part '../reviews/components/submit_review_button_component.dart';
part '../reviews/components/submit_review_modal_component.dart';

part '../reviews/reviews_controller.dart';
part '../reviews/reviews_view.dart';

class Reviews extends StatefulWidget {

  /// The game currently being processed, displayed, or interacted with.
  final Game game;

  const Reviews(this.game, {super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final ConfettiController cConfetti;
  late final HiveRepository rHive;
  late final SupabaseRepository rSupabase;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Reviews handler of ${widget.game.fTitle}...");

    cConfetti = ConfettiController(
      duration: const Duration(
        seconds: 3,
      ),
    );

    rHive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );
    rSupabase = Provider.of<SupabaseRepository>(
      context,
      listen: false,
    );
    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );

    controller = _Controller(
      cConfetti: cConfetti,
      game: widget.game,
      rHive: rHive,
      rSupabase: rSupabase,
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
    Logger.trash("Disposing the Reviews resources of ${widget.game.fTitle}...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget> [
      _View(
        controller: controller,
        localizations: localizations,
      ),
      Confetti(cConfetti),
    ],
  );
}