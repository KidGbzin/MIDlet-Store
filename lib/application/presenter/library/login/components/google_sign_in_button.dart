part of '../login_handler.dart';

class _GoogleSignInButton extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _GoogleSignInButton({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  
  @override
  Widget build(BuildContext context) {
    return ButtonWidget.widget(
      color: Palettes.foreground.value,
      onTap: () {
        widget.controller.nProgress.value = ProgressEnumeration.isLoading;
        widget.controller.googleSignIn(context);
      },
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: <Widget> [
            SizedBox.square(
              dimension: 25,
              child: Image.asset(
                'assets/brands/Google.png',
                filterQuality: FilterQuality.high,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                widget.localizations.buttonLoginWithGoogle.toUpperCase(),
                maxLines: 1,
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}