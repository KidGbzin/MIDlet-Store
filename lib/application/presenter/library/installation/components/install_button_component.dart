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
        child: ButtonWidget.widget(
          width: double.infinity,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext _) => _InstallModal(
                controller: widget.controller,
                localizations: widget.localizations,
              ),
            );
          },
          color: ColorEnumeration.primary.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 7.5,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                child: Text(
                  "INSTALL", // TODO: Translate.
                  style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
                ),
              ),
              Icon(
                HugeIcons.strokeRoundedDownload01,
                color: ColorEnumeration.elements.value,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}