part of '../midlets_handler.dart';

class _ListView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _ListView({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  late final List<MIDlet> midlets = widget.controller.game.midlets;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: midlets.length + (midlets.length ~/ 5),
      itemBuilder: (BuildContext context, int index) {
        if ((index + 1) % 6 == 0) {
          return AdvertisementWidget(widget.controller.sAdMob);
        }
        final int iMIDlet = index - (index ~/ 6);

        return _ListTile(
          controller: widget.controller,
          localizations: widget.localizations,
          midlet: midlets[iMIDlet],
        );
      },
      separatorBuilder: (BuildContext _, int __) => gDivider,
    );
  }
}