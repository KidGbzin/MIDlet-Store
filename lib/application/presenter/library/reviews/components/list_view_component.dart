part of '../reviews_handler.dart';

class _ListView extends StatefulWidget {

  final _Controller controller;

  const _ListView({
    required this.controller,
  });

  @override
  State<_ListView> createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  late final List<Review> reviews = widget.controller._reviews;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        widget.controller.sAdMob.preloadNearbyAdvertisements(index, AdSize.mediumRectangle);

        if ((index + 1) % 6 == 0) {
          return Advertisement.banner(
            advertisement: widget.controller.sAdMob.getAdvertisementByIndex(index),
          );
        }

        final int iReview = index - (index ~/ 6);

        return _ListTile(
          review: reviews[iReview],
        );
      },
      itemCount: reviews.length + (reviews.length ~/ 5),
      separatorBuilder: (BuildContext _, int __) => gDivider
    );
  }
}

class _ListTile extends StatelessWidget {

  final Review review;

  const _ListTile({
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
      child: Column(
        spacing: 7.5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 7.5,
            children: [
              Text(
                "${localeToFlagEmoji(review.locale)} GABRIEL",
                style: TypographyEnumeration.headline(Palettes.elements).style,
              ),
              Text(
                review.fRelativeDate(review.locale),
                style: TypographyEnumeration.body(Palettes.grey).style,
              ),
            ],
          ),
          RatingStarsWidget(rating: review.rating.toDouble()),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 7.5, 0, 0),
            child: Text(
              handleReview(review.body, review.rating),
              style: TypographyEnumeration.body(Palettes.elements).style,
            ),
          ),
        ],
      ),
    );
  }

  String handleReview(String? body, int rating) {
    if (body != null && body.isNotEmpty) return body;

    switch (rating) {
      case 1: return "Really disappointing. Didn't enjoy it at all. 😞";
      case 2: return "Not great. It has some serious flaws. 😕";
      case 3: return "It's okay, but there's room for improvement. 😐";
      case 4: return "Pretty good! Had a lot of fun. 👍";
      case 5: return "This game is awesome, I love it! 😍";
      default: return "...";
    }
  }

  String localeToFlagEmoji(String locale) {
    final parts = locale.split('_');
    if (parts.length != 2) return '🌐';

    final countryCode = parts[1].toUpperCase();
    if (countryCode.length != 2) return '🌐';

    return countryCode
        .split('')
        .map((char) => String.fromCharCode(0x1F1E6 + char.codeUnitAt(0) - 'A'.codeUnitAt(0)))
        .join('');
  }
}