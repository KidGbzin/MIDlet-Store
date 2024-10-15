import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';

import '../../../external/interfaces/android_interface.dart';
import '../../../external/services/github_service.dart';

import '../../../source/interfaces/database_interface.dart';

import '../../shared/widgets/handler_widget.dart';

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
  late final IDatabase database;

  @override
  void initState() {
    database = Provider.of<IDatabase>(
      context,
      listen: false,
    );
    controller = _Controller(
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
    return Handler(
      message: controller.message,
      progress: controller.progress,
      child: const _Launcher(),
    );
  }
}