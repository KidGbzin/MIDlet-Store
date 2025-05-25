part of '../installation_handler.dart';

class _EmulatorTile extends StatefulWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  /// The [Emulators] instance that this tile represents.
  final Emulators emulator;

  const _EmulatorTile({
    required this.emulator,
    required this.controller,
  });


  @override
  State<_EmulatorTile> createState() => _EmulatorTileState();
}

class _EmulatorTileState extends State<_EmulatorTile> with SingleTickerProviderStateMixin {
  late final AnimationController cAnimation;
  late final Animation<double> animation;
  late final List<ColorTween> tweens;

  late final List<Color> primary = <Color> [
    widget.emulator.primaryColor,
    widget.emulator.accentColor,
  ];

  late final List<Color> secondary = <Color> [
    widget.emulator.accentColor,
    widget.emulator.primaryColor,
  ];

  @override
  void initState() {
    super.initState();

    cAnimation = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );

    animation = CurvedAnimation(
      parent: cAnimation,
      curve: Curves.easeInOut,
    );

    tweens = List.generate(
      primary.length,
      (int index) => ColorTween(
        begin: primary[index],
        end: secondary[index],
      ),
    );
  }

  @override
  void dispose() {
    cAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: gBorderRadius,
      onTap: () {
        widget.controller.nEmulator.value = widget.emulator;
      },
      child: ValueListenableBuilder<Emulators>(
        valueListenable: widget.controller.nEmulator,
        builder: (BuildContext context, Emulators selectedEmulator, Widget? _) {
          final bool isSelected = widget.emulator == selectedEmulator;

          if (isSelected) {
            cAnimation.repeat(
              reverse: true,
            );
          }
          else {
            cAnimation.stop();
          }

          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? _) {
              return Ink(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorEnumeration.divider.value,
                    width: 1,
                  ),
                  borderRadius: gBorderRadius,
                  color: color(isSelected),
                  gradient: gradient(isSelected),
                ),
                height: 100,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  spacing: 7.5,
                  children: <Widget> [
                    Expanded(
                      child: Image.asset(
                        widget.emulator.assetImage,
                        color: ColorEnumeration.elements.value,
                      ),
                    ),
                    Text(
                      widget.emulator.title,
                      style: TypographyEnumeration.body(ColorEnumeration.elements).style,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color? color(isSelected) {
    if (isSelected) return null;

    return ColorEnumeration.background.value;
  }

  LinearGradient? gradient(bool isSelected) {
    if (!isSelected) return null;

    return LinearGradient(
      begin: Alignment.topLeft,
      colors: tweens.map((tween) => tween.evaluate(animation)!).toList(),
      end: Alignment.bottomRight,
    );
  }
}