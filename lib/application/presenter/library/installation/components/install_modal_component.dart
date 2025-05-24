part of '../installation_handler.dart';

class _InstallModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _InstallModal({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_InstallModal> createState() => _InstallModalState();
}

class _InstallModalState extends State<_InstallModal> {

  @override
  void initState() {
    super.initState();

    widget.controller.downloadMIDlet();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: context.pop,
        ),
      ],
      child: Expanded(
        child: ValueListenableBuilder(
          valueListenable: widget.controller.nInstallationState,
          builder: (BuildContext context, ProgressEnumeration installationState, Widget? _) {
            if (installationState == ProgressEnumeration.isLoading) {
              return downloading();
            }
            if (installationState == ProgressEnumeration.requestEmulator) {
              return requestEmulator();
            }
            else {
              Logger.error("Unhandled state \"$installationState\".");

              return SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget downloading() => const LoadingAnimation();

  Widget error() {
    // TODO: Implement an error widget!

    return Center(
      child: Text(
        "Internal error!",
        style: TypographyEnumeration.body(ColorEnumeration.elements).style,
      ),
    );
  }

  Widget requestEmulator() {
    // TODO: Translate this section to the new Emulator too.

    late final List<Widget> badges;

    final Emulators emulator = widget.controller.nEmulator.value;

    if (emulator == Emulators.j2meLoader) {
      badges = <Widget> [
        badge("assets/badges/PlayStore.png", emulator.playStore!),
        badge("assets/badges/GitHub.png", emulator.gitHub),
      ];
    }

    if (emulator == Emulators.jlMod) {
      badges = <Widget> [
        badge("assets/badges/GitHub.png", emulator.gitHub),
      ];
    }

    if (badges.isEmpty) Logger.error("There’s currently no downloadable link for the emulator \"${emulator.title}\".");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget> [
        Section(
          description: AppLocalizations.of(context)!.sectionEmulatorNotFoundDescription,
          title: AppLocalizations.of(context)!.sectionEmulatorNotFound,
        ),
        Divider(
          color: ColorEnumeration.divider.value,
          height: 1,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 22.5, 15, 15),
          child: Text(
            AppLocalizations.of(context)!.sectionEmulatorNotFoundText01,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            spacing: 15,
            children: badges,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
          child: Text(
            AppLocalizations.of(context)!.sectionEmulatorNotFoundText02,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ),
      ],
    );
  }

  Widget badge(String assetImage, String link) {
    return GestureDetector(
      onTap: () {
        widget.controller.launchUrl(link);
      },
      child: SizedBox(
        height: 45,
        child: Image.asset(
          assetImage,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}