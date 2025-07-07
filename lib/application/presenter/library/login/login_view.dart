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
        builder: (BuildContext context, ({Object? error, Progresses progress}) progress, Widget? _) {
          if (progress.progress == Progresses.isLoading) {
            return Align(
              alignment: Alignment.center,
              child: LoadingAnimation(),
            );
          }
          else if (progress.progress == Progresses.requestSignIn) {
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
          else if (progress.progress == Progresses.isFinished) {
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
          else if (progress.progress == Progresses.hasError) {
            return ErrorMessage(progress.error!);
          }
          else {
            return ErrorMessage(StateError);
          }
        },
      ),
    );
  }
}