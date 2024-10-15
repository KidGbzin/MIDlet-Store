part of '../details_handler.dart';

/// Creates a [Widget] that shows a section of the game previews.
class _Preview extends StatefulWidget {

  const _Preview({
    required this.controller,
  });

  /// The [Details] controller.
  /// 
  /// The controller that handles the state of the previews.
  final _Controller controller;

  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.previews,
      builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
        if (snapshot.hasData) {
          final List<Uint8List> previews = snapshot.data!;
          return Section(
            description: 'The game\'s characteristics and previews may vary according to the model of your phone.',
            title: 'Previews',
            child: _previews(previews),
          );
        }
        else if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        else {
          return const SizedBox.shrink();
        }
      }
    );
  }

  Widget _previews(List<Uint8List> previews) {
    final image.Image? frame = image.decodeImage(previews.first);
    final double aspectRatio = frame!.width / frame.height;
    return Container(
      height: (MediaQuery.of(context).size.width - 60) / 3 / aspectRatio,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget> [
          _thumbnail(
            aspectRatio: aspectRatio,
            index: 0,
            previews: previews,
          ),
          _thumbnail(
            aspectRatio: aspectRatio,
            index: 1,
            previews: previews,
          ),
          _thumbnail(
            aspectRatio: aspectRatio,
            index: 2,
            previews: previews,
          ),
        ],
      ),
    );
  }

  Widget _thumbnail({
    required double aspectRatio,
    required int index,
    required List<Uint8List> previews,
  }) {
    return Thumbnail(
      aspectRatio: aspectRatio,
      image: MemoryImage(previews[index]),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialogs.previews(
              aspectRatio: aspectRatio,
              initialPage: index,
              previews: previews,
            );
          },
        );
      },
    );
  }
}