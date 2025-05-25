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
        description: localizations.scExternalSourceDescription.replaceFirst("@source", controller.midlet.source),
        title: localizations.scExternalSource,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
          child: GradientButton(
            icon: HugeIcons.strokeRoundedLink02,
            onTap: () => controller.launchSourceUrl(context),
            text: localizations.btOpenOnBrowser,
          ),
        ),
      ),
    );
  }
}