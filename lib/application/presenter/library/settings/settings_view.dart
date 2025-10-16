part of '../settings/settings_handler.dart';

class _View extends StatelessWidget {

  final _Controller controller;

  const _View(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                "SETTINGS",
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
            SizedBox.square(
              dimension: 40,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget> [
          
        ],
      ),
    );
  }
}