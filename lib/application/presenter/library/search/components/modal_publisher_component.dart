part of '../search_handler.dart';

/// A modal widget that displays a list of publishers to filter by.
///
/// The widget is composed of a list of tiles, each representing a publisher.
/// The selected publisher is then used to filter the list of games.
class _PublisherModal extends StatefulWidget {

  const _PublisherModal({
    required this.controller,
  });

  /// The controller that manages the state of the games list.
  final _Controller controller;

  @override
  State<_PublisherModal> createState() => _PublisherModalState();
}

class _PublisherModalState extends State<_PublisherModal> {
  late final String? _initialState;

  /// The state is initialized with the initial value of the selected publisher,
  /// which is used to reset the selected publisher when the user cancels the modal.
  @override
  void initState() {
    _initialState = widget.controller.selectedPublisherState.value;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWidget(
      actions: <Widget> [
        const Spacer(),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedCancel01,
          onTap: () {
            widget.controller.selectedPublisherState.value = _initialState;
            context.pop();
          },
        ),
        ButtonWidget.icon(
          icon: HugeIcons.strokeRoundedTick02,
          onTap: () {
            widget.controller.applyFilters();
            context.pop();
          },
        ),
      ],
      child: Section(
        description: AppLocalizations.of(context)!.sectionPublisherFiltersDescription,
        title: AppLocalizations.of(context)!.sectionPublisherFilters,
        child: Padding(
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
            children: widget.controller.getPublishers().map(_tile).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds a tile for each publisher with a toggle state.
  ///
  /// The tile displays the publisher's logo and changes color when selected.
  Widget _tile(String publisher) {
    return InkWell(
      borderRadius: kBorderRadius,
      onTap: () {

        // Toggle the publisher selection on tap.
        widget.controller.selectedPublisherState.value == publisher
          ? widget.controller.selectedPublisherState.value = null
          : widget.controller.selectedPublisherState.value = publisher;
      },
      child: ValueListenableBuilder(
        valueListenable: widget.controller.selectedPublisherState,
        builder: (BuildContext context, String? isSelected, Widget? _) {
          return AspectRatio(
            aspectRatio: 1.25,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isSelected == publisher
                  ? ColorEnumeration.primary.value.withAlpha(190)
                  : ColorEnumeration.foreground.value,
              ),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Image.asset(
                'assets/publishers/$publisher.png',
                filterQuality: FilterQuality.high,
                errorBuilder: (BuildContext context, Object error, StackTrace? _) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      publisher,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TypographyEnumeration.body(ColorEnumeration.grey).style,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
