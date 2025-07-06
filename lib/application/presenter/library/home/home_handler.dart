import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../logger.dart';

import '../../../core/entities/game_entity.dart';
import '../../../core/entities/game_metadata_entity.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../core/extensions/router_extension.dart';

import '../../../repositories/bucket_repository.dart';
import '../../../repositories/sembast_repository.dart';
import '../../../repositories/supabase_repository.dart';

import '../../../services/admob_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/game_horizontal_list_widget.dart';

part '../home/home_controller.dart';
part '../home/home_view.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final _Controller controller;
  
  late final BucketRepository rBucket;
  late final SembastRepository rSembast;
  late final SupabaseRepository rSupabase;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Home handler...");

    rBucket = Provider.of<BucketRepository>(
      context,
      listen: false,
    );
    rSembast = Provider.of<SembastRepository>(
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
      rBucket: rBucket,
      rSembast: rSembast,
      rSupabase: rSupabase,
    );
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Home resources...");

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _View(controller);
}