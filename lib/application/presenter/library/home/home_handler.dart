import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:midlet_store/application/core/enumerations/palette_enumeration.dart';
import 'package:midlet_store/application/core/enumerations/tag_enumeration.dart';
import 'package:midlet_store/application/presenter/shared/widgets/section_widget.dart';
import 'package:midlet_store/application/presenter/shared/widgets/thumbnail_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/entities/game_entity.dart';
import '../../../core/enumerations/logger_enumeration.dart';
import '../../../external/services/github_service.dart';
import '../../../source/interfaces/bucket_interface.dart';
import '../../../source/interfaces/database_interface.dart';
import '../../shared/factories/buttons_factory.dart';

part '../home/components/category_component.dart';
part '../home/components/cover_component.dart';

part '../home/views/home_view.dart';

part 'home_controller.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return _HomeView(
      controller: controller,
    );
  }
}