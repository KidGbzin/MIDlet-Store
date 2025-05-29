import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/enumerations/palette_enumeration.dart';

/// A widget that displays a custom confetti animation using the [confetti](https://pub.dev/packages/confetti) package.
class Confetti extends StatelessWidget {

  /// Controls and triggers confetti animations for visual feedback or celebration effects.
  final ConfettiController controller;

  const Confetti(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -150),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: pi,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0,
          numberOfParticles: 100,
          maxBlastForce: 25,
          maximumSize: const Size(50, 50),
          minimumSize: const Size(25, 25),
          minBlastForce: 1,
          colors: <Color> [
            Palettes.gold.value,
          ],
          gravity: 0.25,
          createParticlePath: star,
        ),
      ),
    );
  }

  /// Generates a star-shaped [Path] used for each confetti particle.
  Path star(Size size) {
    double degreesToRadian(double degrees) => degrees * (pi / 180.0);

    const int points = 5;
    final double halfWidth = size.width / 2;
    final double externalRadius = halfWidth;
    final double internalRadius = halfWidth / 2.5;
    final double degreesPerStep = degreesToRadian(360 / points);
    final double halfDegreesPerStep = degreesPerStep / 2;
    final Path path = Path();
    final double fullAngle = degreesToRadian(360);

    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    
    return path;
  }
}