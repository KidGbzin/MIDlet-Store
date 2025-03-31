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
    _initialState = widget.controller.nSelectedPublisher.value;
  
    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context)!;
    widget.controller.fetchFiltersPublishers();
    
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
            widget.controller.nSelectedPublisher.value = _initialState;
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
            child: ValueListenableBuilder(
              valueListenable: widget.controller.nFiltersPublishers,
              builder: (BuildContext context, filters, Widget? _) {
                if (filters == null) {
                  return Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: LoadingAnimation(),
                    ),
                  );
                }
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 7.5,
                    crossAxisSpacing: 7.5,
                    childAspectRatio: 1.25,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: filters.entries.map(_tile).toList(),
                );
              }
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
            widget.controller.nSelectedPublisher.value == publisher
              ? widget.controller.nSelectedPublisher.value = null
              : widget.controller.nSelectedPublisher.value = publisher;
          },
          child: ValueListenableBuilder(
            valueListenable: widget.controller.nSelectedPublisher,
            builder: (BuildContext context, String? isSelected, Widget? _) {
              return Ink(
                decoration: BoxDecoration(
                  borderRadius: gBorderRadius,
                  color: isSelected == publisher
                    ? ColorEnumeration.primary.value.withAlpha(190)
                    : ColorEnumeration.foreground.value,
                ),
                padding: EdgeInsets.all(15),
                child: _buildLogo(publisher),
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildLogo(String publisher) {
    return FutureBuilder(
      future: widget.controller.getPublisherLogo(publisher),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!,
            filterQuality: FilterQuality.high,
          );
        }
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
      }
    );
  }
}