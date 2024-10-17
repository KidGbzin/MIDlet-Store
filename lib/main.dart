import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application.dart';

import '../application/external/interfaces/android_interface.dart';
import '../application/external/interfaces/authentication_interface.dart';
import '../application/external/interfaces/client_interface.dart';

import '../application/external/services/android_service.dart';
import '../application/external/services/authentication_service.dart'; 
import '../application/external/services/github_service.dart';

import '../application/source/interfaces/database_interface.dart';
import '../application/source/interfaces/favorites_interface.dart';
import '../application/source/interfaces/games_interface.dart';
import '../application/source/interfaces/recents_interface.dart';
import '../application/source/interfaces/bucket_interface.dart';

import '../application/source/repositories/bucket_repository.dart';
import '../application/source/repositories/database_repository.dart';
import '../application/source/repositories/favorites_repository.dart';
import '../application/source/repositories/games_repository.dart';
import '../application/source/repositories/recents_repository.dart';


void main() {
  final IAndroid android = Android();
  final IAuthentication authentication = Authentication();
  final IClient gitHub = GitHub(
    client: Client(),
  );
  final IFavorites favorites = Favorites();
  final IGames games = Games();
  final IRecents recents = Recents();

  /// Starts the application using the Provider for dependency injection.
  /// 
  /// These values can be accessed throughout the application.
  runApp(MultiProvider(
    providers: <SingleChildWidget> [
      Provider<IBucket>.value(
        value: Bucket(
          android: android,
          gitHub: gitHub,
        ),
      ),
      Provider<IDatabase>.value(
        value: Database(
          favorites: favorites,
          games: games,
          gitHub: gitHub,
          recents: recents,
        ),
      ),
      Provider<IAuthentication>.value(
        value: authentication,
      ),
    ],
    child: Application(),
  ));
}