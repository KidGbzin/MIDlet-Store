import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presenter/library/details/details_handler.dart';
import '../../presenter/library/installation/installation_handler.dart';
import '../../presenter/library/launcher/launcher_handler.dart';
import '../../presenter/library/login/login_handler.dart';
import '../../presenter/library/midlets/midlets_handler.dart';
import '../../presenter/library/search/search_handler.dart';
import '../../presenter/library/update/update_handler.dart';

import '../entities/game_entity.dart';
import '../entities/midlet_entity.dart';

/// The application's routes.
/// 
/// When redirecting a view never use the default navigator, always use this router from [GoRouter] navigator.
/// Check the architecture document for more information.
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase> [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState _) => const Launcher(),
    ),
    GoRoute(
      path: '/details',
      builder: (BuildContext context, GoRouterState state) => Details(state.extra as Game),
    ),
    GoRoute(
      path: '/installation',
      builder: (BuildContext context, GoRouterState state) {
        final ({Game game, MIDlet midlet}) arguments = state.extra as ({Game game, MIDlet midlet});

        return Installation(
          game: arguments.game,
          midlet: arguments.midlet,
        );
      }
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState _) => const Login(),
    ),
    GoRoute(
      path: '/midlets',
      builder: (BuildContext context, GoRouterState state) {
        final ({File cover, Game game}) arguments = state.extra as ({File cover, Game game});

        return MIDlets(
          cover: arguments.cover,
          game: arguments.game,
        );
      }
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
    GoRoute(
      path: '/update',
      builder: (BuildContext context, GoRouterState _) => const Update(),
    ),
  ],
);