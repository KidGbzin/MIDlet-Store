import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../external/interfaces/android_interface.dart';
import '../../../external/interfaces/authentication_interface.dart';
import '../../../external/services/github_service.dart';

import '../../../source/interfaces/database_interface.dart';

import '../../shared/extensions/messenger_widget.dart';
import '../../shared/factories/buttons_factory.dart';

part '../launcher/views/launcher_view.dart';

part '../launcher/launcher_controller.dart';

class Launcher extends StatefulWidget {

  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  late final _Controller controller;

  late final IAndroid android;
  late final IAuthentication authentication;
  late final IDatabase database;

  @override
  void initState() {
    database = Provider.of<IDatabase>(
      context,
      listen: false,
    );
    authentication = Provider.of<IAuthentication>(
      context,
      listen: false,
    );
    controller = _Controller(
      authentication: authentication,
      database: database,
    )..initialize(context);
  
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Launcher(
      controller: controller,
    );
  }
}