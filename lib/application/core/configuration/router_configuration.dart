import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presenter/library/details/details_handler.dart';
import '../../presenter/library/launcher/launcher_handler.dart';
import '../../presenter/library/search/search_handler.dart';

import '../entities/game_entity.dart';

// ROUTER CONFIGURATION ⚙️: ===================================================================================================================================================== //

/// The application's routes.
/// 
/// When redirecting a view never use the default navigator, always use this router from [GoRouter] navigator.
/// Check the architecture document for more information.
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase> [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState _) {
        return const Launcher();
      },
    ),
    GoRoute(
      path: '/details',
      builder: (BuildContext context, GoRouterState state) {
        final Game game = state.extra as Game;
        return Details(game);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (BuildContext context, GoRouterState state) {
        final String? publisher = state.extra as String?;
        return Search(
          publisher: publisher,
        );
      },
    ),
  ],
);