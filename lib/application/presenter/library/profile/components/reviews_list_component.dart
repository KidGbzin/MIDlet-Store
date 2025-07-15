part of '../profile_handler.dart';

class _Reviews extends StatelessWidget {

  /// Manages all handler.cSearch instances for the Search view.
  final _Controller controller;

  const _Reviews(this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            "LAST UPDATED REVIEWS".toUpperCase(),
            style: TypographyEnumeration.headline(Palettes.elements).style,
            textAlign: TextAlign.start,
          ),
          Text(
            "Showing the user last updated reviews, you can upvote or downvote them.",
            style: TypographyEnumeration.body(Palettes.grey).style,
            textAlign: TextAlign.start,
          ),
          gDivider,
          AsyncBuilder(
            future: controller.getTop5Reviews(),
            onSuccess: (BuildContext context, List<({Review review, String title})> reviews) {
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return _ReviewTile(
                    controller: controller,
                    review: reviews[index].review,
                    title: reviews[index].title,
                  );
                },
                shrinkWrap: true,
                itemCount: reviews.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: gDivider,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}