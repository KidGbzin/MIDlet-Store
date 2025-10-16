import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:midlet_store/application/core/entities/active_filters_entity.dart';

import '../../../l10n/l10n_localizations.dart';

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

  void gtSearchFilters({
    required ActiveFilters activeFilters,
    required List<Game> games,
    required Future<void> Function(ActiveFilters) onApply,
  }) {
    final arguments = (
      active: activeFilters,
      games: games,
      onApply: onApply,
      l10n: AppLocalizations.of(this)!,
    );
    
    push(
      '/search/filters',
      extra: arguments,
    );
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