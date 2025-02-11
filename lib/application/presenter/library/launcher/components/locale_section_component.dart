part of '../launcher_handler.dart';

/// A stateful widget for displaying the "Select a Locale" state.
///
/// This widget is displayed when the user's locale is not set.
/// When a button is tapped, the associated locale is set and the user is redirected to the authentication flow.
class _LocaleView extends StatefulWidget {

  const _LocaleView({
    required this.controller,
  });

  final _Controller controller;

  @override
  State<_LocaleView> createState() => _LocaleViewState();
}

class _LocaleViewState extends State<_LocaleView> {
  late AppLocalizations appLocalizations;

  @override
  void didChangeDependencies() {
    appLocalizations = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: <Widget> [
        button(
          l10n: L10nEnumeration.brazilianPortuguese,
          onTap: () async {
            localeState.value = L10nEnumeration.brazilianPortuguese.locale;
            widget.controller.setLocale(L10nEnumeration.brazilianPortuguese.locale);
            await widget.controller.fetchAndAutheticateUser();
          }
        ),
        button(
          l10n: L10nEnumeration.english,
          onTap: () async {
            localeState.value = L10nEnumeration.english.locale;
            widget.controller.setLocale(L10nEnumeration.english.locale);
            await widget.controller.fetchAndAutheticateUser();
          }
        ),
      ],
    );
  }

  /// A method that creates a button with a flag and a label from a locale enumeration.
  Widget button({
    required L10nEnumeration l10n,
    required VoidCallback onTap,
  }) {
    return ButtonWidget.widget(
      color: ColorEnumeration.foreground.value,
      onTap: onTap,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 15,
        children: <Widget> [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(l10n.iconPath),
                fit: BoxFit.cover,
              ),
            ),
            height: 25,
            width: 25,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
            child: Text(
              l10n.label,
              style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
            ),
          ),
        ],
      ),
    );
  }
}
