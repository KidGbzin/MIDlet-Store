part of '../midlets/midlets_handler.dart';

class _MIDletsView extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _MIDletsView({
    required this.controller,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            const Spacer(),
            _MIDletsCounter(controller),
          ],
        ),
      ),
      body: _ListView(
        controller: controller,
        localizations: localizations,
      ),
    );
  }
}