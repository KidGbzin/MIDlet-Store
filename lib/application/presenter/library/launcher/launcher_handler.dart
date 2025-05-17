import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';

import '../../../core/extensions/router_extension.dart';

import '../../../services/admob_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/github_service.dart';
import '../../../services/supabase_service.dart';

import '../../../repositories/hive_repository.dart';

import '../../widgets/loading_widget.dart';

part '../launcher/launcher_controller.dart';
part '../launcher/launcher_view.dart';

class Launcher extends StatefulWidget {

  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final HiveRepository rHive;
  late final AdMobService sAdMob;
  late final FirebaseMessagingService sFirebaseMessaging;
  late final GitHubService sGitHub;
  late final SupabaseService sSupabase;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Launcher handler...");

    rHive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );
    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );
    sFirebaseMessaging = Provider.of<FirebaseMessagingService>(
      context,
      listen: false,
    );
    sGitHub = Provider.of<GitHubService>(
      context,
      listen: false,
    );
    sSupabase = Provider.of<SupabaseService>(
      context,
      listen: false,
    );
  
    controller = _Controller(
      rHive: rHive,
      sAdMob: sAdMob,
      sFirebaseMessaging: sFirebaseMessaging,
      sGitHub: sGitHub,
      sSupabase: sSupabase,
    );
    controller.initialize(context);
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Launcher resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _LauncherView(
    controller: controller,
    localizations: localizations,
  );
}