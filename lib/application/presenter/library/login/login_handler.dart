import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../services/authentication_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/supabase_service.dart';

import '../../widgets/button_widget.dart';
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

  late final FirebaseMessagingService sFirebaseMessaging;
  late final GoogleOAuthService sGoogleOAuth;
  late final SupabaseService sSupabase;

  @override
  void initState() {
    super.initState();

    Logger.start.log("Initializing the Login handler...");

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
      sFirebaseMessaging: sFirebaseMessaging,
      sGoogleOAuth: sGoogleOAuth,
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
    Logger.dispose.log("Disposing the Login resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _LoginView(
    controller: controller,
    localizations: localizations,
  );
}