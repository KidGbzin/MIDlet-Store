part of '../login/login_handler.dart';

class _LoginView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _LoginView({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_LoginView> createState() => __LoginViewState();
}

class __LoginViewState extends State<_LoginView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: widget.controller.nProgress,
        builder: (BuildContext context, ProgressEnumeration progress, Widget? _) {
          if (progress == ProgressEnumeration.isLoading) {
            return Align(
              alignment: Alignment.center,
              child: LoadingAnimation(),
            );
          }
          else if (progress == ProgressEnumeration.requestSignIn) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 150, 15, 150),
              child: Column(
                children: <Widget> [
                  const Spacer(),
                  _GoogleSignInButton(
                    controller: widget.controller,
                    localizations: widget.localizations,
                  ),
                ],
              ),
            );
          }
          else if (progress == ProgressEnumeration.isFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.controller.handleNotificationMessage(context);
            });

            return Center(
              child: Text(
                "Redirecting...",
                style: TypographyEnumeration.body(Palettes.elements).style,
              ),
            );
          }
          else if (progress == ProgressEnumeration.hasError) {
            return SizedBox();
          }
          else {
            Logger.error('Encountered an unhandled Login progress state: "${progress.name.toUpperCase()}". This state should be handled explicitly!');

            return SizedBox();
          }
        },
      ),
    );
  }
}