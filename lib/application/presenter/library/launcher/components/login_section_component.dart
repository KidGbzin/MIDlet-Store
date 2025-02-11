part of '../launcher_handler.dart';

/// A widget that represents the login section of the launcher.
///
/// The [_LoginSection] widget contains the login button and spaces it appropriately within the UI.
/// It is a stateless widget that requires a [_Controller] for managing the state.
class _LoginSection extends StatelessWidget {

  const _LoginSection({
    required this.controller,
  });

  /// The controller that manages the login state and actions.
  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        const Spacer(),
        _LoginButton(
          controller: controller,
        ),
      ],
    );
  }
}

/// A button that is used to sign in to the application using Google Authentication.
///
/// When tapped, the button will start the authentication process with Google.
class _LoginButton extends StatelessWidget {

  const _LoginButton({
    required this.controller,
  });

  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget.widget(
      color: ColorEnumeration.foreground.value,
      onTap: () {
        controller.progressState.value = ProgressEnumeration.loading;
        controller.signIn(context);
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
                AppLocalizations.of(context)!.buttonLoginWithGoogle.toUpperCase(),
                maxLines: 1,
                style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
