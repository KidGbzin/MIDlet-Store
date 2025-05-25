part of '../installation_handler.dart';

class _SourceModal extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SourceModal(this.controller, this.localizations);

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: () => context.pop(),
        ),
      ],
      child: Section(
        description: "This MIDlet file is available at \"${controller.midlet.source}\". To view the original file, please open the link in your web browser.\n\nPlease note: This is an external website with no official affiliation to the MIDlet Store project.",
        title: "YOU ARE BEING REDIRECTED",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          child: GradientButton(
            icon: HugeIcons.strokeRoundedLink02,
            onTap: () => controller.launchSourceUrl(context),
            text: "OPEN ON BROWSER",
          ),
        ),
      ),
    );
  }
}