part of '../details_handler.dart';

/// A section widget that displays the installation section of the game details.
/// 
/// This section displays a button to either play the game or indicate that the game is not yet available.
/// If the game has MIDlets, the button is enabled and tapping it will open the installation modal.
/// If the game does not have MIDlets, the button is disabled and displays a message indicating that the game is not yet available.
class _InstallationSection extends StatefulWidget {

  /// The [Details] controller.
  /// 
  /// The controller that handles the state and installation of the MIDlets.
  final _Controller controller;

  const _InstallationSection({
    required this.controller,
  });

  @override
  State<_InstallationSection> createState() => _InstallationSectionState();
}

class _InstallationSectionState extends State<_InstallationSection> {
  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: localizations.sectionInstallationDescription,
      title: localizations.sectionInstallation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: _buildPlayButton(),
      ),
    );
  }

  /// Builds the button that is displayed in the installation section.
  /// 
  /// If the game has MIDlets, the button is enabled and tapping it will open the installation modal.
  /// If the game does not have MIDlets, the button is disabled and displays a message indicating that the game is not yet available.
  Widget _buildPlayButton() {
    if (widget.controller.game.midlets.isNotEmpty) {
      return ButtonWidget.widget(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return _InstallationModal(
                controller: widget.controller,
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 7.5,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                localizations.buttonPlay,
                style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedPlay,
              color: ColorEnumeration.elements.value,
              size: 25,
            ),
          ],
        ),
      ); 
    }
    else {
      return ButtonWidget.widget(
        color: ColorEnumeration.foreground.value,
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 7.5,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                localizations.buttonCommingSoon,
                style: TypographyEnumeration.headline(ColorEnumeration.grey).style,
              ),
            ),
          ],
        ),
      ); 
    }
  }
}
