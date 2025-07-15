import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/core/configuration/global_configuration.dart';
import 'package:midlet_store/application/presenter/widgets/error_message_widget.dart';
import 'package:midlet_store/application/presenter/widgets/gradient_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/router_extension.dart';

import '../../../interfaces/controller_interface.dart';
import '../../../repositories/supabase_repository.dart';
import '../../../services/google_authentication_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/supabase_service.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/handler_widget.dart';
import '../../widgets/loading_widget.dart';

part '../login/components/google_sign_in_button.dart';

part '../login/login_controller.dart';
part '../login/login_view.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final SupabaseRepository rSupabase;
  late final FirebaseMessagingService sFirebaseMessaging;
  late final GoogleOAuthService sGoogleOAuth;
  late final SupabaseService sSupabase;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Login handler...");

    rSupabase = Provider.of<SupabaseRepository>(
      context,
      listen: false,
    );
    sFirebaseMessaging = Provider.of<FirebaseMessagingService>(
      context,
      listen: false,
    );
    sGoogleOAuth = Provider.of<GoogleOAuthService>(
      context,
      listen: false,
    );
    sSupabase = Provider.of<SupabaseService>(
      context,
      listen: false,
    );

    controller = _Controller(
      rSupabase: rSupabase,
      sFirebaseMessaging: sFirebaseMessaging,
      sGoogleOAuth: sGoogleOAuth,
      sSupabase: sSupabase,
    )..initialize();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Login resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Handler(
    nProgress: controller.nProgress,
    onReady: _LoginView(controller),
  );
}