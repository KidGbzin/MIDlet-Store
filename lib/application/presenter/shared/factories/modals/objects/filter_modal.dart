part of '../modals_factory.dart';

/// Creates a [Modals.filter] content showing the filters available.
class _Filter extends StatelessWidget {

  const _Filter({
    required this.publisherState,
    required this.tagsState,
  });

  /// The current state of the publisher filter.
  /// 
  /// This state is handled by the [Search] controller.
  final ValueNotifier<String?> publisherState;

  /// The current state of the tags filter.
  /// 
  /// This state is handled by the [Search] controller.
  final ValueNotifier<List<String>> tagsState;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget> [
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            description: 'Refine your search by selecting from various category tags.',
            title: 'Categories',
            child: _Categories(
              tagsState: tagsState,
            ),
          ),
        ),
        Divider(
          color: Palette.divider.color,
          thickness: 1,
          height: 1,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            description: 'Discover games by filtering through different publishers.',
            title: 'Publishers',
            child: _Publishers(
              publisherState: publisherState,
            ),
          ),
        ),
      ],
    );
  }
}