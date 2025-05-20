part of '../details_handler.dart';

class _ActionsSection extends StatefulWidget {

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _ActionsSection(this.localizations);

  @override
  State<_ActionsSection> createState() => __ActionsSectionState();
}

class __ActionsSectionState extends State<_ActionsSection> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorEnumeration.foreground.value,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 7.5,
        children: <Widget> [
          //TODO: Translate this section.
          //TODO: Convert to action buttons.
          Expanded(
            child: _wActionButton("MIDlets", HugeIcons.strokeRoundedJava),
          ),
          Expanded(
            child: _wActionButton("Soundtrack", HugeIcons.strokeRoundedMusicNote04),
          ),
          Expanded(
            child: _wActionButton("Favourite", HugeIcons.strokeRoundedFavourite),
          ),
          Expanded(
            child: _wActionButton("Share", HugeIcons.strokeRoundedShare03),
          ),
        ],
      ),
    );
  }

  Widget _wActionButton(String action, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: gBorderRadius,
        color: ColorEnumeration.foreground.value,
      ),
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Column(
        spacing: 7.5,
        children: <Widget> [
          Icon(
            icon,
            color: ColorEnumeration.elements.value,
            size: 25,
          ),
          Text(
            action,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyEnumeration.body(ColorEnumeration.grey).style,
          ),
        ],
      ),
    );
  }
}