import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/l10n_localizations.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../services/activity_service.dart';
import '../../../services/authentication_service.dart';
import '../../../services/github_service.dart';
import '../../../services/supabase_service.dart';

import '../../../repositories/hive_repository.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/loading_widget.dart';

part '../launcher/components/login_section_component.dart';

part '../launcher/views/launcher_view.dart';

part '../launcher/launcher_controller.dart';

/// The root view of the application.
/// 
/// This view serves as the application's entry point.
/// It manages authentication services and initializes the necessary data required for the application to function correctly upon startup.
class Launcher extends StatefulWidget {

  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  late final _Controller controller;

  late final ActivityService activity;
  late final AuthenticationService authentication;
  late final GitHubService gitHub;
  late final HiveRepository hive;
  late final SupabaseService supabase;

  @override
  void initState() {
    activity = Provider.of<ActivityService>(
      context,
      listen: false,
    );
    authentication = Provider.of<AuthenticationService>(
      context,
      listen: false,
    );
    gitHub = Provider.of<GitHubService>(
      context,
      listen: false,
    );
    hive = Provider.of<HiveRepository>(
      context,
      listen: false,
    );
    supabase = Provider.of<SupabaseService>(
      context,
      listen: false,
    );
  
    controller = _Controller(
      activityService: activity,
      gitHub: gitHub,
      googleAuthentication: authentication,
      hive: hive,
      supabase: supabase,
    );
    controller.initialize(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _LauncherView(controller);
  }
}