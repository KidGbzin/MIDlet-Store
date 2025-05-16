import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../entities/game_entity.dart';

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

  void gtUpdate() async => pushReplacement('/update');

  void gtLogin() async => pushReplacement('/login');
}