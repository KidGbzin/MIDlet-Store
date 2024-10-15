part of '../modals_factory.dart';

/// Create a [Wrap] of tags filters.
class _Categories extends StatelessWidget {

  const _Categories({
    required this.tagsState,
  });

  /// The current state of the tags filter.
  /// 
  /// This state is handled by the [Search] controller.
  final ValueNotifier<List<String>> tagsState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Wrap(
        runSpacing: 7.5,
        spacing: 7.5,
        children: Tag.values.map(_tile).toList(),
      ),
    );
  }

  /// Build the [tag] tile with a toggle state.
  Widget _tile(Tag tag) {
    final ValueNotifier<bool> isSelected = ValueNotifier<bool>(tagsState.value.contains(tag.name));
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        if (tagsState.value.contains(tag.name)) {
          tagsState.value.remove(tag.name);
        }
        else {
          tagsState.value.add(tag.name);
        }
        isSelected.value = !isSelected.value;
      },
      child: ValueListenableBuilder(
        valueListenable: isSelected,
        builder: (BuildContext context, bool isSelected, Widget? _) {
          return FittedBox(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isSelected ? Palette.primary.color.withOpacity(0.75) : Palette.foreground.color,
              ),
              height: 30,
              padding: const EdgeInsets.fromLTRB(12.5, 0, 12.5, 0),
              child: Row(
                children: <Widget> [
                  Icon(
                    tag.icon,
                    color: Palette.grey.color,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7.5, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        tag.name,
                        style: Typographies.tags(Palette.grey).style,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}