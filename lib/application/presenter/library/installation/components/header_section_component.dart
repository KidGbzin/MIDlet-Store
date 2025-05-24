part of '../installation_handler.dart';

class _HeaderSection extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _HeaderSection(this.controller, this.localizations);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 0, 25),
            child: title(),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
          width: MediaQuery.sizeOf(context).width / 4,
          child: logo(),
        ),
      ],
    );
  }

  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: <Widget> [
        Text(
          controller.midlet.formattedTitle.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
        ),
        Text(
          controller.midlet.brand,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TypographyEnumeration.body(ColorEnumeration.grey).style,
        ),
      ],
    );
  }

  Widget logo() {
    return Image.asset(
      "assets/brands/${controller.midlet.brand}.png",
      errorBuilder: (BuildContext _, Object __, StackTrace? ___) {
        return Icon(
          HugeIcons.strokeRoundedBrandfetch,
          size: 18,
          color: ColorEnumeration.grey.value,
        );
      },
    );
  }
}