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
  late final ValueNotifier<(int, int)?> nScore;

  @override
  void initState() {
    super.initState();

    nScore = ValueNotifier<(int, int)?>(null);

    fetchScore();
  }

  @override
  void dispose() {
    nScore.dispose();
    
    super.dispose();
  }

  Future<void> submitVote(int vote) async {
    nScore.value = await widget.controller.submitVote(widget.review, vote);
  }

  Future<void> fetchScore() async {
    nScore.value = await widget.controller.getReviewScore(widget.review);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nScore,
      builder: (BuildContext context, (int, int)? score, Widget? _) {
        Widget child;

        if (score == null) {
          child = LoadingAnimation();
        }

        else {
          child = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 7.5,
            children: <Widget> [
              voteButton(
                color: score.$2 == 1 ? Palettes.green.value : Palettes.grey.value,
                icon: HugeIcons.strokeRoundedThumbsUp,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                voteValue: 1,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    score.$1.toString(),
                    style: TypographyEnumeration.number(Palettes.grey).style,
                  ),
                ),
              ),
              voteButton(
                color: score.$2 == -1 ? Palettes.red.value : Palettes.grey.value,
                icon: HugeIcons.strokeRoundedThumbsDown,
                padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                voteValue: -1,
              ),
            ],
          );
        }
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: gBorderRadius,
            color: Palettes.foreground.value,
          ),
          height: 35,
          width: 125,
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

  Widget voteButton({
    required Color color,
    required IconData icon,
    required EdgeInsets padding,
    required int voteValue,
  }){
    assert(voteValue == 1 || voteValue == -1);

    return GestureDetector(
      onTap: () {
        if (nScore.value!.$2 != voteValue) {
          nScore.value = null;
          submitVote(voteValue);
        }
      },
      child: Container(
        height: 35,
        padding: padding,
        width: 35,
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }
}