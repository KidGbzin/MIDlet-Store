part of '../update/update_handler.dart';

class _UpdateView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _UpdateView({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_UpdateView> createState() => __UpdateViewState();
}

class __UpdateViewState extends State<_UpdateView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 150, 15, 150),
        child: Column(
          children: <Widget> [
            const Spacer(),
            _UpdateButton(
              controller: widget.controller,
              localizations: widget.localizations,
            ),
          ],
        ),
      ),
    );
  }
}