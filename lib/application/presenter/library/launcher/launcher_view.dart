part of '../launcher/launcher_handler.dart';

class _LauncherView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _LauncherView({
    required this.controller,
    required this.localizations
  });

  @override
  State<_LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<_LauncherView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 100, 25, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: <Widget> [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: widget.controller.nProgress,
                builder: (BuildContext context, ProgressEnumeration progress, Widget? _) {
                  Widget child = const SizedBox.shrink();

                  if (progress == ProgressEnumeration.isLoading) {
                    child = Align(
                      alignment: Alignment.center,
                      child: LoadingAnimation(),
                    );
                  }
                  else if (progress == ProgressEnumeration.requestUpdate) {
                 
                  }
                  else if (progress == ProgressEnumeration.isFinished) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) context.pushReplacement('/search');
                    });
                  }
                  else {
                    child = Align(
                      alignment: Alignment.center,
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedAlert01,
                        color: ColorEnumeration.grey.value,
                      ),
                    );
                  }
                  return AnimatedSwitcher(
                    duration: Durations.extralong4,
                    child: child,
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}