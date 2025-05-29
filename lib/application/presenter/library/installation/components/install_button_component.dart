part of "../installation_handler.dart";

class _InstallButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _InstallButton({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_InstallButton> createState() => _InstallButtonState();
}

class _InstallButtonState extends State<_InstallButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Align(
        alignment: Alignment.center,
        child: GradientButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext _) => _InstallModal(
                controller: widget.controller,
                localizations: widget.localizations,
              ),
            );
          },
          icon: HugeIcons.strokeRoundedDownload01,
          text: widget.localizations.btInstallOnEmulator,
        ),
      ),
    );
  }
}