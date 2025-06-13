part of '../reviews_handler.dart';

class _ListView extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _ListView({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.nReviews,
      builder: (BuildContext context, List<Review> reviews, Widget? _) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            widget.controller.sAdMob.preloadNearbyAdvertisements(index, AdSize.mediumRectangle);
        
            if ((index + 1) % 6 == 0) {
              return Advertisement.banner(
                advertisement: widget.controller.sAdMob.getAdvertisementByIndex(index),
              );
            }
        
            final int iReview = index - (index ~/ 6);
        
            return _ReviewTile(
              controller: widget.controller,
              localizations: widget.localizations,
              review: reviews[iReview],
            );
          },
          itemCount: reviews.length + (reviews.length ~/ 5),
          separatorBuilder: (BuildContext _, int __) => gDivider
        );
      }
    );
  }
}