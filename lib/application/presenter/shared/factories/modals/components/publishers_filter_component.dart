part of '../modals_factory.dart';

/// Create a [GridView] of publisher filters.
class _Publishers extends StatefulWidget {

  const _Publishers({
    required this.publisherState,
  });

  /// The current state of the publisher filter.
  /// 
  /// This state is handled by the [Search] controller.
  final ValueNotifier<String?> publisherState;

  @override
  State<_Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<_Publishers> {
  final List<String> publishers = <String> [
    'Digital Chocolate',
    'Electronic Arts, Inc.',
    'Gameloft SA',
    'Glu Mobile LLC',
    'I-play',
    'Konami Digital Entertainment, Inc.',
    'Micazook Ltd.',
    'Nano Games',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 7.5,
          crossAxisSpacing: 7.5,
          childAspectRatio: 1.25,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: publishers.map(_tile).toList(),
      ),
    );
  }

  /// Build the [publisher] tile with a toggle state.
  Widget _tile(String publisher) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        widget.publisherState.value == publisher
          ? widget.publisherState.value = null
          : widget.publisherState.value = publisher;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.publisherState,
        builder: (BuildContext context, String? isSelected, Widget? _) {
          return AspectRatio(
            aspectRatio: 1.25,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isSelected == publisher ? Palette.primary.color.withOpacity(0.75) : Palette.foreground.color,
              ),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Image.asset(
                'assets/publishers/$publisher.png',
                filterQuality: FilterQuality.high,
              ),
            ),
          );
        }
      ),
    );
  }
}