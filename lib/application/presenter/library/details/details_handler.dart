import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as image;
import 'package:provider/provider.dart';

import '../../../core/entities/game_entity.dart';
import '../../../core/entities/midlet_entity.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';

import '../../../external/services/activity_service.dart';
import '../../../external/services/github_service.dart';

import '../../../source/interfaces/bucket_interface.dart';
import '../../../source/interfaces/database_interface.dart';

import '../../shared/extensions/messenger_widget.dart';

import '../../shared/factories/buttons_factory.dart';
import '../../shared/factories/dialogs_factory.dart';

import '../../shared/factories/modals/modals_factory.dart';
import '../../shared/widgets/handler_widget.dart';
import '../../shared/widgets/section_widget.dart';
import '../../shared/widgets/thumbnail_widget.dart';

part '../details/components/about_section_component.dart';
part '../details/components/bookmark_button_component.dart';
part '../details/components/cover_section_component.dart';
part '../details/components/install_section_component.dart';
part '../details/components/preview_section_component.dart';

part '../details/views/details_view.dart';

part '../details/details_controller.dart';

/// Screen responsible for displaying all the game's data and available MIDlets for installation.
class Details extends StatefulWidget {
  
  const Details(this.title, {super.key});

  /// The title of the game, used as a key to retrieve the game from the database.
  final String title;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late _Controller controller;
  late IBucket bucket;
  late IDatabase database;

  @override
  void initState() {
    bucket = Provider.of<IBucket>(
      context,
      listen: false,
    );
    database = Provider.of<IDatabase>(
      context,
      listen: false,
    );
    controller = _Controller(
      bucket: bucket,
      database: database,
    );
    controller.initialize(widget.title);
  
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
      message: ValueNotifier(""),
      progress: controller.progress,
      child: _Details(
        controller: controller,
      ),
    );
  }
}