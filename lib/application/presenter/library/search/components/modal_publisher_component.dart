part of '../search_handler.dart';

// PUBLISHER MODAL 🏢: ========================================================================================================================================================== //

/// A modal widget that displays a list of publishers to filter by.
///
/// The widget is composed of a list of tiles, each representing a publisher.
/// The selected publisher is then used to filter the list of games.
class _PublisherModal extends StatefulWidget {

  const _PublisherModal(this.controller);

  /// The controller that manages the state of the games list.
  final _Controller controller;

  @override
  State<_PublisherModal> createState() => _PublisherModalState();
}

class _PublisherModalState extends State<_PublisherModal> {
  late final String? _initialState;
  late final AppLocalizations localizations;

  @override
  void initState() {
    _initialState = widget.controller.selectedPublisherState.value;
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    
    super.didChangeDependencies();
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
            widget.controller.applyFilters(context, localizations);
            context.pop();
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Section(
          description: AppLocalizations.of(context)!.sectionFilterPublisherDescription,
          title: AppLocalizations.of(context)!.sectionFilterPublisher,
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
              children: widget.controller.getPublishers().entries.map(_tile).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a tile for each publisher with a toggle state.
  ///
  /// The tile displays the publisher's logo and changes color when selected.
  Widget _tile(MapEntry<String, int> entry) {
    final String publisher = entry.key;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          borderRadius: gBorderRadius,
          onTap: () {
        
            // Toggle the publisher selection on tap.
            widget.controller.selectedPublisherState.value == publisher
              ? widget.controller.selectedPublisherState.value = null
              : widget.controller.selectedPublisherState.value = publisher;
          },
          child: ValueListenableBuilder(
            valueListenable: widget.controller.selectedPublisherState,
            builder: (BuildContext context, String? isSelected, Widget? _) {
              return Ink(
                decoration: BoxDecoration(
                  borderRadius: gBorderRadius,
                  color: isSelected == publisher
                    ? ColorEnumeration.primary.value.withAlpha(190)
                    : ColorEnumeration.foreground.value,
                ),
                child: Column(
                  children: <Widget> [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Image.asset(
                          'assets/publishers/$publisher.png',
                          filterQuality: FilterQuality.high,
                          errorBuilder: (BuildContext context, Object error, StackTrace? _) {
                            return Icon(
                              HugeIcons.strokeRoundedImage02,
                              color: ColorEnumeration.grey.value,
                              size: 18,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          publisher,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TypographyEnumeration.body(ColorEnumeration.grey).style,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }
}