import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/configuration/global_configuration.dart';

import '../../../core/entities/midlet_entity.dart';

import '../../../core/enumerations/language_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../services/admob_service.dart';

import '../../widgets/advertisement_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/section_widget.dart';

part '../installation/components/details_section_component.dart';
part '../installation/components/emulator_section_component.dart';
part '../installation/components/header_section_component.dart';

part '../installation/installation_controller.dart';
part '../installation/installation_view.dart';

class Installation extends StatefulWidget {

   /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  const Installation(this.midlet, {super.key});

  @override
  State<Installation> createState() => _InstallationState();
}

class _InstallationState extends State<Installation> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final AdMobService sAdMob;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Installation handler of \"${widget.midlet.file}\"...");

    sAdMob = Provider.of<AdMobService>(
      context,
      listen: false,
    );

    controller = _Controller(
      sAdMob: sAdMob,
    );
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Installation resources...");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InstallationView(
    controller: controller,
    localizations: localizations,
    midlet: widget.midlet,
  );
}