import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/interfaces/controller_interface.dart';
import 'package:midlet_store/application/presenter/widgets/handler_widget.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';
import '../../widgets/button_widget.dart';

part '../settings/settings_controller.dart';
part '../settings/settings_view.dart';

class Settings extends StatefulWidget {

  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final _Controller controller;

  @override
  void dispose() {
    controller.dispose();
    
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = _Controller()..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Handler(
      nProgress: controller.nProgress,
      onReady: _View(controller),
    );
  }
}