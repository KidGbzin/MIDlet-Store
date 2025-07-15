import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../entities/game_entity.dart';
import '../entities/midlet_entity.dart';

extension RouterExtension on BuildContext {
  
  void gtDetails({
    required Game game,
    bool? replace = false,
  }) {
    if (replace == true) {
      pushReplacement(
        '/details',
        extra: game,
      );
    }
    else {
      push(
        '/details',
        extra: game,
      );
    }
  }

  void gtSearch({
    String? publisher,
    bool? replace = false,
  }) {
    if (replace == true) {
      pushReplacement(
        '/search',
        extra: publisher,
      );
    }
    else {
      push(
        '/search',
        extra: publisher,
      );
    }
  }

  void gtInstallation({
    required Game game,
    required MIDlet midlet,
    bool? replace = false,
  }) {
    final ({Game game, MIDlet midlet}) arguments = (
      game: game,
      midlet: midlet,
    );

    if (replace == true) {
      pushReplacement(
        '/installation',
        extra: arguments,
      );
    }
    else {
      push(
        '/installation',
        extra: arguments,
      );
    }
  }

  void gtReviews(Game game, {
    bool replace = false,
  }) {
    if (replace) {
      pushReplacement(
        '/reviews',
        extra: game,
      );
    }
    else {
      push(
        '/reviews',
        extra: game,
      );
    }
  }

  void gtMIDlets(Game game, {
    bool replace = false,
  }) {
    if (replace) {
      pushReplacement(
        '/midlets',
        extra: game,
      );
    }
    else {
      push(
        '/midlets',
        extra: game,
      );
    }
  }

  void gtHome({
    bool replace = false,
  }) {
    replace ? pushReplacement('/home') : push('/home');
  }

  void gtProfile({
    bool replace = false,
  }) {
    replace ? pushReplacement('/profile') : push('/profile');
  }

  void gtUpdate() => pushReplacement('/update');

  void gtLogin() => pushReplacement('/login');
}