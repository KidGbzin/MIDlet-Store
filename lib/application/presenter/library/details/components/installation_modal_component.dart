part of '../details_handler.dart';

/// A modal widget for handling the installation process of a MIDlet.
class _InstallationModal extends StatefulWidget {

  const _InstallationModal({
    required this.controller,
  });

  /// The controller managing the installation state and operations.
  final _Controller controller;

  @override
  State<_InstallationModal> createState() => _InstallationModalState();
}

class _InstallationModalState extends State<_InstallationModal> {

  @override
  void initState() {
    widget.controller.getMIDlet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget>[
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: () {
            context.pop();
          },
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: widget.controller.installationState,
        builder: (BuildContext context, ProgressEnumeration progress, Widget? _) {
          if (progress == ProgressEnumeration.loading) {
            return LoadingAnimation();
          }
          else if (progress == ProgressEnumeration.ready) {
            return _ReadyToInstall(
              controller: widget.controller,
            );
          }
          else if (progress == ProgressEnumeration.error) {
            return Center(
              child: Text(
                '...',
                style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
              ),
            );
          }
          else if (progress == ProgressEnumeration.emulatorNotFound) {
            return _EmulatorNotFound(
              controller: widget.controller,
            );
          }
          else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

/// A widget displayed when the emulator is not found.
///
/// Provides options to download the emulator from the PlayStore or GitHub.
class _EmulatorNotFound extends StatelessWidget {

  const _EmulatorNotFound({
    required this.controller,
  });

  /// The controller managing the installation state and operations.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        GestureDetector(
          onTap: controller.openPlayStore,
          child: Container(
            height: 45,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Image.asset(
              'assets/badges/PlayStore.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        InkWell(
          onTap: controller.openGitHub,
          child: Container(
            height: 45,
            margin: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/badges/GitHub.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
          child: Text(
            AppLocalizations.of(context)!.sectionEmulatorNotFoundText02,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ),
      ],
    );
  }
}

/// A stateful widget for displaying the "Ready to Install" state.
///
/// Provides information about the MIDlet and an install button.
class _ReadyToInstall extends StatefulWidget {

  const _ReadyToInstall({
    required this.controller,
  });

  /// The controller managing the installation state and operations.
  final _Controller controller;

  @override
  State<_ReadyToInstall> createState() => _ReadyToInstallState();
}

/// The state of the [_ReadyToInstall] widget.
///
/// Manages the display of MIDlet information and the install button.
class _ReadyToInstallState extends State<_ReadyToInstall> {
  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
          child: Text(
            widget.controller.game.title.replaceFirst(' -', ':').toUpperCase(),
            style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: _buildMIDLetInformation(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
          child: _buildInstallButton(),
        ),
      ],
    );
  }

  /// Builds an information row with an icon and text.
  Widget _information(IconData icon, String body) {
    return Row(
      spacing: 7.5,
      children: <Widget> [
        HugeIcon(
          icon: icon,
          color: ColorEnumeration.grey.value,
          size: 18,
        ),
        Expanded(
          child: Text(
            body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ),
      ],
    );
  }

  /// Builds the MIDlet information section.
  Widget _buildMIDLetInformation() {
    final MIDlet midlet = widget.controller.game.midlets.firstWhere((midlet) => midlet.isDefault);

    List<Widget> children = <Widget> [
      _information(HugeIcons.strokeRoundedJava, midlet.file),
      _information(HugeIcons.strokeRoundedSmartPhone01, midlet.resolution.replaceFirst('x', ' x ')),
      _information(HugeIcons.strokeRoundedSourceCode, "${localizations.labelVersion}: ${midlet.version}"),
      _information(HugeIcons.strokeRoundedPackage, "${localizations.labelSize}: ${(midlet.size / 1024).round()} KB"),
      _information(HugeIcons.strokeRoundedGlobe02, midlet.languages.reduce((x, y) => "$x • $y")),
    ];

    if (midlet.isTouchscreen) children.add(_information(HugeIcons.strokeRoundedTouch08, localizations.labelTouchscreen));
    if (midlet.isMultiscreen) children.add(_information(HugeIcons.strokeRoundedMaximizeScreen, localizations.labelMultiscreen));
    if (midlet.isLandscape) children.add(_information(HugeIcons.strokeRoundedSmartPhoneLandscape, localizations.labelLandscape));
    if (midlet.isThreeD) children.add(_information(HugeIcons.strokeRoundedThreeDView, localizations.label3DVersion));
    if (midlet.isCensored) children.add(_information(HugeIcons.strokeRoundedUnavailable, localizations.labelCensored));
    if (midlet.isMultiplayerB) children.add(_information(HugeIcons.strokeRoundedBluetooth, localizations.labelMultiplayerBluetooth));
    if (midlet.isMultiplayerL) children.add(_information(HugeIcons.strokeRoundedUserMultiple02, localizations.labelMultiplayerLocal));
    if (midlet.isOnline) children.add(_information(HugeIcons.strokeRoundedUserGroup, localizations.labelMultiplayerOnline));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 7.5,
      children: children,
    );
  }

  /// Builds the install button widget.
  Widget _buildInstallButton() {
    return ButtonWidget.widget(
      onTap: () {
        widget.controller.tryInstallMIDlet();
      },
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 1, 0, 0),
          child: Text(
            localizations.buttonReadyToInstall,
            style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
          ),
        ),
      ),
    );
  }
}