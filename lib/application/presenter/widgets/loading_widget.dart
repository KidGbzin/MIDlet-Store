import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/enumerations/palette_enumeration.dart';

// LOADING WIDGET 🧩: =========================================================================================================================================================== //

/// A widget that displays a rotating loading icon.
///
/// The [LoadingAnimation] uses an [AnimationController] to rotate the icon continuously, providing a visual indication of loading or processing.
class LoadingAnimation extends StatefulWidget {

  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2500,
      ),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.1416,
          child: child,
        );
      },
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedLoading03,
        color: ColorEnumeration.elements.value,
        size: 25,
      ),
    );
  }
}
