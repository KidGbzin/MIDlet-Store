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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 0, 25),
            child: title(),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
          width: MediaQuery.sizeOf(context).width / 4,
          child: logo(),
        ),
      ],
    );
  }

  Widget title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: <Widget> [
        Text(
          widget.controller.game.formattedTitle.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TypographyEnumeration.headline(ColorEnumeration.elements).style,
        ),
        Text(
          "${widget.controller.game.release} • ${widget.controller.game.publisher}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TypographyEnumeration.body(ColorEnumeration.grey).style,
        ),
      ],
    );
  }

  Widget logo() {
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