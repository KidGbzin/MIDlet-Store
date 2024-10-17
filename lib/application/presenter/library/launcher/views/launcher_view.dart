part of '../launcher_handler.dart';

class _Launcher extends StatelessWidget {

  const _Launcher({
    required this.controller,
  });

  final _Controller controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 75, 15, 100),
        child: Column(
          children: <Widget> [
            Placeholder(),
            Spacer(),
            ValueListenableBuilder(
              valueListenable: controller.progress,
              builder: (BuildContext context, Progress progress, Widget? _) {
                if (progress == Progress.loading) {
                  return SizedBox(
                    height: 40,
                    width: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircularProgressIndicator(
                        color: Palette.elements.color,
                      ),
                    ),
                  );
                }
                else if (progress == Progress.loginRequest) {
                  return Button.withTitle(
                    icon: Icons.login_rounded,
                    title: 'Sign in with Google',
                    onTap: () {
                      controller.login(context);
                    },
                  );
                }
                else {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      controller.message,
                      style: Typographies.body(Palette.elements).style,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}