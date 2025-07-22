part of '../reviews_handler.dart';

class _ReviewsList extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _ReviewsList(this.controller);

  @override
  State<_ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<_ReviewsList> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.nReviews,
      builder: (BuildContext context, List<Review> reviews, Widget? _) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            if (reviews.length >= 6) widget.controller.preloadNearbyAdvertisements(index);
        
            if ((index + 1) % 6 == 0) {
              return Advertisement.banner(widget.controller.getAdvertisementByIndex(index));
            }
        
            final int iReview = index - (index ~/ 6);
        
            return _ReviewTile(
              controller: widget.controller,
              review: reviews[iReview],
            );
          },
          itemCount: reviews.length + (reviews.length ~/ 5),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 45 + 25), // FAB padding design.
          separatorBuilder: (BuildContext _, int __) => gDivider
        );
      }
    );
  }
}