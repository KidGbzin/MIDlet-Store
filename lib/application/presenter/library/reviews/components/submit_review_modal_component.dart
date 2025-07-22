part of '../reviews_handler.dart';

class _SubmitReviewModal extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _SubmitReviewModal(this.controller);

  @override
  State<_SubmitReviewModal> createState() => _SubmitReviewModalState();
}

class _SubmitReviewModalState extends State<_SubmitReviewModal> {
  TextEditingController? cTextField = TextEditingController();

  late final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nProgress = ValueNotifier((
    state: Progresses.isLoading,
    error: null,
  ));

  late final ValueNotifier<Review> nReview = ValueNotifier(Review.empty());
  late final AppLocalizations l10n = AppLocalizations.of(context)!;
  late Review lastReview = Review.empty();

  @override
  initState() {
    super.initState();

    getOwnReview();
  }

  @override
  void dispose() {
    if (cTextField != null) cTextField!.dispose();
    nProgress.dispose();
    nReview.dispose();

    super.dispose();
  }

  Future<void> getOwnReview() async {
    lastReview = await widget.controller.getUserReview();
    nReview.value = lastReview;

    cTextField = TextEditingController(
      text: lastReview.comment,
    );

    nProgress.value = (
      state: Progresses.isReady,
      error: null,
    );
  }

  Future<void> submitReview() async {
    try {
      await widget.controller.submitReview(nReview.value);

      nProgress.value = (
        state: Progresses.isFinished,
        error: null,
      );
    }
    catch (error, stackTrace) {
      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );

      nProgress.value = (
        state: Progresses.hasError,
        error: error,
      );
    }
  }

  void onTimeSpentUpdate(int value) {
    nReview.value = nReview.value.copyWith(
      timeSpent: value,
    );
  }

  void onDifficultyUpdate(int value) {
    nReview.value = nReview.value.copyWith(
      difficulty: value,
    );
  }

  void onCompletionLevelUpdate(int value) {
    nReview.value = nReview.value.copyWith(
      completionLevel: value,
    );
  }
  
  void onRateUpdate(int value) {
    nReview.value = nReview.value.copyWith(
      rating: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Handler(
      isWidget: true,
      nProgress: nProgress,
      onReady: modal(body()),
      initialize: getOwnReview,
    );
  }

  ModalWidget modal(Widget child) {
    return ModalWidget(
        actions: <Widget> [
          SizedBox.square(
            dimension: 40,
          ),
          const Spacer(),
          Text(
            l10n.btSubmitRating,
            style: TypographyEnumeration.headline(Palettes.elements).style,
          ),
          const Spacer(),
          ButtonWidget.icon(
            icon: HugeIcons.strokeRoundedCancel01,
            onTap: context.pop,
          ),
        ],
        child: Expanded(
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
        ),
      );
  }

  Widget throbber() {
    return Align(
      alignment: Alignment.center,
      child: LoadingAnimation(),
    );
  }

  Widget body() {
    return ValueListenableBuilder(
      valueListenable: nReview,
      builder: (BuildContext context, Review review, Widget? _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: <Widget> [
                RatingSliders.star(lastReview.rating, onRateUpdate),
                gDivider,
                RatingSliders.difficulty(lastReview.difficulty, onDifficultyUpdate),
                gDivider,
                RatingSliders.playthroughTime(lastReview.playthroughTime, onTimeSpentUpdate),
                gDivider,
                Playthrough(),
                textBox(),
                _SubmitReviewButton(
                  onSubmitReview: submitReview,
                  nReview: nReview,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget textBox() {
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
          helperText: l10n.txSubmitReview,
        ),
        style: TypographyEnumeration.body(Palettes.elements).style,
      ),
    );
  }
}

class Playthrough extends StatefulWidget {

  const Playthrough({super.key});

  @override
  State<Playthrough> createState() => _PlaythroughState();
}

class _PlaythroughState extends State<Playthrough> {
  int _selectedIndex = 0; // 0 = Played, 1 = Beat, 2 = Conquered
int _animatingIndex = -1;

  void _onTap(int index) async {
  setState(() {
    _selectedIndex = index;
    _animatingIndex = index;
  });

  // Espera 200ms e remove o efeito pulse
  await Future.delayed(const Duration(milliseconds: 500));
  if (mounted) {
    setState(() {
      _animatingIndex = -1;
    });
  }
}

Widget _buildItemContainer({
  required int index,
  required IconData icon,
  required String label,
  required Color backgroundColor,
  required Color iconColor,
  required TextStyle textStyle,
}) {
  final content = Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: gBorderRadius,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 70,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 7.5),
        Align(
          alignment: Alignment.center,
          child: Text(label, style: textStyle),
        ),
      ],
    ),
  );

  // Envolve com brilho dourado se for o "Conquered It" selecionado
  return content;
}


  Widget _buildItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color backgroundColor = isSelected ? Palettes.primary.value : Colors.transparent;
    final Color iconColor = isSelected ? Palettes.elements.value : Palettes.disabled.value;
    final TextStyle textStyle = TypographyEnumeration.body(
      isSelected ? Palettes.elements : Palettes.disabled
    ).style;
  
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: isSelected ? 0.75 : 1.0,
            end: isSelected ? 1.0 : 0.75,
          ),
          duration: Durations.long2,
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
    scale: scale,
    child: _buildItemContainer(
      index: index,
      icon: icon,
      label: label,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      textStyle: textStyle,
    ),
  );

        },
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildItem(
          index: 0,
          icon: HugeIcons.strokeRoundedGameController03,
          label: "Played It",
        ),
        _buildItem(
          index: 1,
          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
          label: "Beat It",
        ),
        _buildItem(
          index: 2,
          icon: HugeIcons.strokeRoundedCrown,
          label: "Conquered It",
        ),
      ],
    );
  }
}