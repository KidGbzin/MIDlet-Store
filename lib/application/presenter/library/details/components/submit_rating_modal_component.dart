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
  late final ValueNotifier<int> nRating;
  late final ValueNotifier<Progresses> nState;
  
  late final AppLocalizations localizations;
  late final int initialRating;
  late final String? initialBody;
  late final TextEditingController cTextField;

  @override
  initState() {
    super.initState();

    nRating = ValueNotifier<int>(widget.controller.nGameMetadata.value!.myReview!.rating);
    nState = ValueNotifier(Progresses.isWaiting);
    
    initialRating = widget.controller.nGameMetadata.value!.myReview!.rating;
    initialBody = widget.controller.nGameMetadata.value!.myReview!.comment;
    localizations = widget.localizations;

    cTextField = TextEditingController(
      text: initialBody,
    );
  }

  @override
  void dispose() {
    cTextField.dispose();
    nRating.dispose();
    nState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nState,
      builder: (BuildContext context, Progresses state, Widget? _) {
        Widget child;

        if (state == Progresses.isWaiting) {
          child = Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget> [
                  section(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: textField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: submitButton(),
                  ),
                ],
              ),
            ),
          );
        }
        else if (state == Progresses.isLoading) {
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

  Widget textField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: gBorderRadius,
        border: Border.all(
          color: Palettes.divider.value,
          width: 1,
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      height: 150,
      child: TextField(
        controller: cTextField,
        minLines: null,
        maxLines: null,
        expands: true,
        maxLength: 256,
        cursorColor: Palettes.primary.value,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7.5),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Palettes.transparent.value,
              width: 0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: Palettes.transparent.value,
              width: 0,
            ),
          ),
          helperStyle: TypographyEnumeration.body(Palettes.grey).style,
          helperText: widget.localizations.txSubmitReview,
        ),
        style: TypographyEnumeration.body(Palettes.elements).style,
      ),
    );
  }

  Widget section() {
    return ValueListenableBuilder(
      valueListenable: widget.controller.nGameMetadata,
      builder: (BuildContext context, GameMetadata? metadata, Widget? _) {
        return Section(
          description: metadata!.myReview!.rating == 0
            ? localizations.scSubmitRatingDescriptionNotRated
            : localizations.scSubmitRatingDescriptionRated.replaceFirst("@star", "${nRating.value}"),
          
          title: localizations.scSubmitRating,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
            child: Align(
              alignment: Alignment.center,
              child: RatingBar(
                initialRating: metadata.myReview!.rating.toDouble(),
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
                    color: Palettes.divider.value,
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
        final bool isReadyToSubmit = (rating != 0 && rating != initialRating) ||
                                     (rating != 0 && cTextField.value.text != initialBody);

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
          nState.value = Progresses.isLoading;
          widget.controller.submitRating(context, rating, cTextField.text);
        }
        catch (error) {
          nState.value = Progresses.hasError;
        }
      },
      text: localizations.btSubmitRating,
    );
  }
}