part of '../launcher_handler.dart';

class _LauncherView extends StatefulWidget {

  const _LauncherView(this.controller);

  final _Controller controller;

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

                  if (progress == ProgressEnumeration.loading) {
                    child = Align(
                      alignment: Alignment.center,
                      child: LoadingAnimation(),
                    );
                  }
                  else if (progress == ProgressEnumeration.isOutdated) {
                    child = ButtonWidget.widget(
                      color: ColorEnumeration.foreground.value,
                      onTap: widget.controller.goToReleases,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                          child: Text(
                            AppLocalizations.of(context)!.buttonUpdateAvailable.toUpperCase(),
                            maxLines: 1,
                            style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
                          ),
                        ),
                      ),
                    );
                  }
                  else if (progress == ProgressEnumeration.loginRequest) {
                    child = _LoginSection(
                      controller: widget.controller,
                    );
                  }
                  else if (progress == ProgressEnumeration.finished) {
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