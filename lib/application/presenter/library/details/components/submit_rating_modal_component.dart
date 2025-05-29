part of '../details_handler.dart';

class _SubmitRatingModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Provides localized strings and messages based on the user’s language and region.
  final AppLocalizations localizations;

  const _SubmitRatingModal({
    required this.controller,
    required this.localizations,
  });

  @override
  State<_SubmitRatingModal> createState() => _SubmitRatingModalState();
}

class _SubmitRatingModalState extends State<_SubmitRatingModal> with SingleTickerProviderStateMixin {
  late final ValueNotifier<int> nRating = ValueNotifier<int>(widget.controller.nGameMetadata.value!.myRating!);
  late final ValueNotifier<ProgressEnumeration> nState = ValueNotifier(ProgressEnumeration.isWaiting);
  
  late final AppLocalizations localizations = widget.localizations;

  @override
  void dispose() {
    nRating.dispose();
    nState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nState,
      builder: (BuildContext context, ProgressEnumeration state, Widget? _) {
        Widget child;

        if (state == ProgressEnumeration.isWaiting) {
          child = SizedBox(
            height: 268,
            child: Column(
              children: <Widget> [
                section(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: submitButton(),
                ),
              ],
            ),
          );
        }
        else if (state == ProgressEnumeration.isLoading) {
          child = Container(
            height: 268, // The default size of the modal's body.
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
            child: Align(
              alignment: Alignment.center,
              child: LoadingAnimation(),
            ),
          );
        }
        else {
          child = Icon(
            HugeIcons.strokeRoundedAlert01,
            color: Palettes.grey.value,
            size: 18,
          );
        }

        return ModalWidget(
          actions: <Widget> [
            const Spacer(),
            ButtonWidget.icon(
              icon: HugeIcons.strokeRoundedCancel01,
              onTap: context.pop,
            ),
          ],
          child: AnimatedSize(
            duration: gAnimationDuration,
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: Durations.long2,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget section() {
    return ValueListenableBuilder(
      valueListenable: widget.controller.nGameMetadata,
      builder: (BuildContext context, GameData? metadata, Widget? _) {
        return Section(
          description: metadata!.myRating == 0
            ? localizations.scSubmitRatingDescriptionNotRated
            : localizations.scSubmitRatingDescriptionRated.replaceFirst("@star", "${nRating.value}"),
          
          title: localizations.scSubmitRating,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
            child: Align(
              alignment: Alignment.center,
              child: RatingBar(
                initialRating: metadata.myRating!.toDouble(),
                itemSize: 50,
                glow: false,
                onRatingUpdate: (double rating) {
                  nRating.value = rating.toInt();
                },
                ratingWidget: RatingWidget(
                  full: Icon(
                    HugeIcons.strokeRoundedStar,
                    color: Palettes.gold.value,
                  ),
                  half: Icon(
                    HugeIcons.strokeRoundedStarHalf,
                    color: Palettes.gold.value,
                  ),
                  empty: Icon(
                    HugeIcons.strokeRoundedStar,
                    color: Palettes.disabled.value,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget submitButton() {
    return ValueListenableBuilder(
      valueListenable: nRating,
      builder: (BuildContext context, int rating, Widget? _) {
        final bool isReadyToSubmit = (rating != 0 && rating != widget.controller.nGameMetadata.value!.myRating!);

        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: AnimatedSwitcher(
            duration: Durations.long2,
            child: isReadyToSubmit ? activeButton(rating) : disabledButton(),
          ),
        );
      },
    );
  }

  Widget disabledButton() {
    return GradientButton(
      key: Key("Disabled-Button"),
      icon: HugeIcons.strokeRoundedUnavailable,
      onTap: () {},
      primaryColor: Palettes.foreground,
      secondaryColor: Palettes.foreground,
      text: localizations.btUpdateYourRating,
    );
  }

  Widget activeButton(int rating) {
    return GradientButton(
      key: Key("Active-Button"),
      icon: HugeIcons.strokeRoundedSent,
      onTap: () {
        try {
          nState.value = ProgressEnumeration.isLoading;
          widget.controller.submitRating(context, rating);
        }
        catch (error) {
          nState.value = ProgressEnumeration.hasError;
        }
      },
      text: localizations.btSubmitRating,
    );
  }
}