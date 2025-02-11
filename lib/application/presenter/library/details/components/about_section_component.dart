part of '../details_handler.dart';

/// A widget that displays the game description section.
///
/// This section presents brief information about the game, providing users with insights into its content and features.
class _About extends StatefulWidget {

  const _About({
    required this.description,
  });

  /// A brief description of the game.
  final String? description;

  @override
  State<_About> createState() => _AboutState();
}

class _AboutState extends State<_About> {
  late final AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      description: widget.description ?? "...",
      title: localizations.sectionAbout,
    );
  }
}