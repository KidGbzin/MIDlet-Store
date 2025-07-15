part of '../login/login_handler.dart';

class _LoginView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _LoginView(this.controller);

  @override
  State<_LoginView> createState() => __LoginViewState();
}

class __LoginViewState extends State<_LoginView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 100, 15, 100),
        child: Column(
          spacing: 25,
          children: [
            Expanded(
              child: Placeholder(),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: widget.controller.nLoginState,
                builder: (BuildContext context, ({Object? error, _States state}) progress, Widget? _) {
                  if (progress.state == _States.isLoading) return onLoading();
                  if (progress.state == _States.requestSignIn) return onLoginRequest(context);
                  if (progress.state == _States.isReady) return onLoginSuccess(context);
    
                  return Placeholder();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onLoginSuccess(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.handleNotificationMessage(context);
    });
                  
    return Center(
      child: Text(
        "Welcome, Gabriel!",
        style: TypographyEnumeration.body(Palettes.elements).style,
      ),
    );
  }

  Widget onLoginRequest(BuildContext context) {
    return Column(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Text(
          "SIGN IN WITH GOOGLE",
          style: TypographyEnumeration.headline(Palettes.elements).style,
        ),
        Text(
          "By continuing, you agree to follow the community guidelines and understand that this platform is dedicated to the preservation and discovery of classic mobile games."
          "\nPlease log in to access your library, submit reviews, and explore our growing collection.",
          textAlign: TextAlign.start,
          style: TypographyEnumeration.body(Palettes.elements).style,
        ),
        Text(
          "By continuing, you agree to our Terms of Use and Privacy Policy.",
          textAlign: TextAlign.start,
          style: TypographyEnumeration.body(Palettes.elements).style,
        ),
        _GoogleSignInButton(widget.controller),
      ],
    );
  }

  Widget onLoading() {
    return Align(
      alignment: Alignment.center,
      child: LoadingAnimation(),
    );
  }
}