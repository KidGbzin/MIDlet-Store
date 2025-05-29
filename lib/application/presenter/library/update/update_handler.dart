import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/l10n_localizations.dart';

import '../../../../logger.dart';

import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../services/activity_service.dart';

import '../../widgets/button_widget.dart';

part '../update/components/update_button.dart';

part '../update/update_controller.dart';
part '../update/update_view.dart';

class Update extends StatefulWidget {

  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late final _Controller controller;
  late final AppLocalizations localizations;

  late final ActivityService sActivity;

  @override
  void initState() {
    super.initState();

    Logger.start("Initializing the Update handler...");

    sActivity = Provider.of<ActivityService>(
      context,
      listen: false,
    );

    controller = _Controller(
      sActivity: sActivity,
    );
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Logger.trash("Disposing the Update resources...");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _UpdateView(
    controller: controller,
    localizations: localizations,
  );
}