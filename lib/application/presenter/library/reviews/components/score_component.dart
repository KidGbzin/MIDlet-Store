part of '../reviews_handler.dart';

class _Score extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// Contains the user's review data, such as rating, comment, and metadata.
  final Review review;

  const _Score({
    required this.controller,
    required this.review,
  });

  @override
  State<_Score> createState() => _ScoreState();
}

class _ScoreState extends State<_Score> {
  late final ValueNotifier<({
    Progresses state,
    Review review,
    Object? error,
  })> nProgress = ValueNotifier((
    state: Progresses.isReady,
    review: widget.review,
    error: null,
  ));

  Future<void> submitVote(int vote) async {
    if (nProgress.value.review.userVote == vote) return;
    
    nProgress.value = (
      state: Progresses.isLoading,
      review: widget.review,
      error: null,
    );

    try {
      final Review review = await widget.controller.submitVote(widget.review, vote);

      nProgress.value = (
        state: Progresses.isReady,
        review: review,
        error: null,
      );
    }
    catch (error, stackTrace) {
      nProgress.value = (
        state: Progresses.hasError,
        review: nProgress.value.review,
        error: error,
      );

      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nProgress,
      builder: (BuildContext context, ({Object? error, Progresses state, Review review}) progress, Widget? _) {
        Widget child;

        if (progress.state == Progresses.isLoading) {
          child = onLoading();
        }
        else if (progress.state == Progresses.isReady) {
          child = body(progress.review);
        }
        else {
          child = onError();
        }
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: Palettes.background.value,
          ),
          width: 125,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 30,
          child: AnimatedSwitcher(
            duration: gAnimationDuration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: child,
          ),
        );
      }
    );
  }

  Widget onError() {
    return Align(
      alignment: Alignment.center,
      child: Icon(
        HugeIcons.strokeRoundedBug02,
        color: Palettes.red.value,
        size: gIconSmall,
      ),
    );
  }

  Widget body(Review review) {
    return Row(
      children: <Widget> [
        button(
          color: review.userVote == 1 ? Palettes.green.value : Palettes.disabled.value,
          icon: HugeIcons.strokeRoundedThumbsUp,
          vote: 1,
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Text(
            review.score.toString(),
            style: TypographyEnumeration.body(Palettes.grey).style,
          ),
        ),
        const Spacer(),
        button(
          color: review.userVote == -1 ? Palettes.red.value : Palettes.disabled.value,
          icon: HugeIcons.strokeRoundedThumbsDown,
          vote: -1,
        ),
      ],
    );
  }

  Widget onLoading() {
    return Align(
      alignment: Alignment.center,
      child: LoadingAnimation(
        size: gIconSmall,
      ),
    );
  }

  Widget button({
    required Color color,
    required IconData icon,
    required int vote,
  }){
    assert(vote == 1 || vote == -1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => submitVote(vote),
      child: Icon(
        icon,
        size: gIconSmall,
        color: color,
      ),
    );
  }
}