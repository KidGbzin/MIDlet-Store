part of '../details_handler.dart';

class _About extends StatelessWidget {

  /// A brief description of the game.
  final String? description;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _About({
    required this.description,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Section(
      description: description ?? "...",
      title: localizations.scAbout,
    );
  }
}