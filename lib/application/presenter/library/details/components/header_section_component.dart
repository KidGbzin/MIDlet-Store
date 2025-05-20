part of '../details_handler.dart';

class _HeaderSection extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _HeaderSection(this.controller);

  @override
  State<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> {

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget> [
        Expanded(
          child: Section(
            description: "${widget.controller.game.release} • ${widget.controller.game.publisher}",
            title: widget.controller.game.title.replaceFirst(" -", ":"),
          ),
        ),
        Ink(
          height: 100,
          padding: EdgeInsets.fromLTRB(0, 25, 15, 25),
          width: MediaQuery.sizeOf(context).width / 4,
          child: Align(
            alignment: Alignment.center,
            child: _wPublisherLogo(),
          ),
        ),
      ],
    );
  }

  Widget _wPublisherLogo() {
    return FutureBuilder(
      future: widget.controller.publisherLogo,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!,
            filterQuality: FilterQuality.high,
          );
        }
        if (snapshot.hasError) {
          return Icon(
            HugeIcons.strokeRoundedImage02,
            color: ColorEnumeration.grey.value,
            size: 18,
          );
        }
        return Align(
          alignment: Alignment.center,
          child: LoadingAnimation(),
        );
      }
    );
  }
}