import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:midlet_store/application/core/entities/review_entity.dart';
import 'package:midlet_store/application/presenter/widgets/async_builder_widget.dart';
import 'package:midlet_store/application/presenter/widgets/handler_widget.dart';
import 'package:midlet_store/application/presenter/widgets/section_widget.dart';
import 'package:midlet_store/application/repositories/supabase_repository.dart';
import 'package:provider/provider.dart';

import '../../../../logger.dart';
import '../../../core/configuration/global_configuration.dart';
import '../../../core/entities/game_entity.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/progress_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';
import '../../../interfaces/controller_interface.dart';
import '../../../repositories/bucket_repository.dart';
import '../../../repositories/sembast_repository.dart';
import '../../../services/admob_service.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/error_message_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/rating_stars_widget.dart';

part '../profile/components/review_tile_component.dart';
part '../profile/components/reviews_list_component.dart';

part '../profile/profile_controller.dart';
part '../profile/profile_view.dart';

class Profile extends StatefulWidget {

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final _Controller controller;
  
  late final BucketRepository rBucket;
  late final SembastRepository rSembast;
  late final SupabaseRepository rSupabase;
  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Update handler...");

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
      // rBucket: rBucket,
      rSembast: rSembast,
      rSupabase: rSupabase,
      // sAdMob: sAdMob,
    )..initialize();
  }

  @override
  Widget build(BuildContext context) => Handler(
    nProgress: controller.nProgress,
    onReady: _View(controller),
  );
}