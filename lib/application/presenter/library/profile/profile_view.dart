part of '../profile/profile_handler.dart';

class _View extends StatefulWidget {

  /// Manages all handler.cSearch instances for the Search view.
  final _Controller controller;

  const _View(this.controller);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              onTap: context.pop,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
              child: Text(
                "PROFILE",
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
            ),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedPencilEdit02,
              onTap: () => {},
            ),
          ],
        ),
      ),
      body: _Reviews(widget.controller),
    );
  }
}