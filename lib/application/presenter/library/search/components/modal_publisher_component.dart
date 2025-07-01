part of '../search_handler.dart';

class _PublisherModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _PublisherModal(this.controller, this.localizations);

  @override
  State<_PublisherModal> createState() => _PublisherModalState();
}

class _PublisherModalState extends State<_PublisherModal> {
  late final String? initialPublisher = widget.controller.nSelectedFilters.value.publisher;
  late final AppLocalizations localizations = widget.localizations;

  @override
  void initState() {
    widget.controller.fetchFilters(localizations);
  
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
            widget.controller.updateSelectedFilters(
              publisher: initialPublisher,
            );
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
      child: Expanded(
        child: SingleChildScrollView(
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Section(
      description: localizations.sectionFilterPublisherDescription,
      title: localizations.sectionFilterPublisher,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: ValueListenableBuilder(
          valueListenable: widget.controller.nFilters,
          builder: (BuildContext context, filters, Widget? _) {
            if (filters.publishers.isEmpty) {
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
              children: filters.publishers.entries.map(tile).toList(),
            );
          }
        ),
      ),
    );
  }

  Widget tile(MapEntry<String, int> entry) {
    final String publisher = entry.key;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          borderRadius: gBorderRadius,
          onTap: () {
            if (widget.controller.nSelectedFilters.value.publisher == publisher) {
              widget.controller.updateSelectedFilters(
                publisher: null,
              );
            }
            else {
              widget.controller.updateSelectedFilters(
                publisher: publisher,
              );
            }
          },
          child: ValueListenableBuilder(
            valueListenable: widget.controller.nSelectedFilters,
            builder: (BuildContext context, ({List<String> categories, String? publisher, int? year})? selectedFilters, Widget? _) {
              return Ink(
                decoration: BoxDecoration(
                  borderRadius: gBorderRadius,
                  color: selectedFilters!.publisher == publisher
                    ? Palettes.primary.value.withAlpha(190)
                    : Palettes.foreground.value,
                ),
                padding: EdgeInsets.all(15),
                child: logo(publisher),
              );
            },
          ),
        );
      }
    );
  }

  Widget logo(String publisher) {
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
            style: TypographyEnumeration.body(Palettes.grey).style,
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }
}