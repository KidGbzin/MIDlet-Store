import 'dart:io';

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

  void gtInstallation(MIDlet midlet, {
    bool? replace = false,
  }) {
    if (replace == true) {
      pushReplacement(
        '/installation',
        extra: midlet,
      );
    }
    else {
      push(
        '/installation',
        extra: midlet,
      );
    }
  }

  void gtMIDlets({
    required File cover,
    required List<MIDlet> midlets,
    bool? replace = false,
  }) {
    final ({File cover, List<MIDlet> midlets}) arguments = (
      cover: cover,
      midlets: midlets,
    );

    if (replace == true) {
      pushReplacement(
        '/midlets',
        extra: arguments,
      );
    }
    else {
      push(
        '/midlets',
        extra: arguments,
      );
    }
  }

  void gtUpdate() => pushReplacement('/update');

  void gtLogin() => pushReplacement('/login');
}