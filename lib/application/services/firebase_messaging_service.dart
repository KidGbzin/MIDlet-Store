import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../core/entities/game_entity.dart';

import '../core/extensions/router_extension.dart';

import '../core/enumerations/logger_enumeration.dart';

import '../repositories/hive_repository.dart';
import '../repositories/supabase_repository.dart';

/// A service class responsible for managing Firebase Cloud Messaging (FCM) functionality.
///
/// This class leverages the [firebase_messaging](https://pub.dev/packages/firebase_messaging) package to request notification permissions and handle the FCM setup process.
/// It also processes incoming messages when the application is in the foreground, background, or terminated state, and manages the lifecycle of the FCM token as needed.
class FirebaseMessagingService {

  /// Manages local storage operations, including games, favorites, recent games, and cached requests.
  final HiveRepository rHive;

  /// Manages remote storage operations through Supabase, including database interactions and data synchronization.
  final SupabaseRepository rSupabase;

  FirebaseMessagingService({
    required this.rHive,
    required this.rSupabase,
  });

  final FirebaseMessaging _instance = FirebaseMessaging.instance;

  RemoteMessage? _message;

  /// Initializes the Firebase Cloud Messaging (FCM) service.
  ///
  /// Should be called on application startup (e.g., in the `Launcher`).
  /// It requests notification permissions, handles initial messages (if the app was terminated), sets up listeners for message events, and registers the FCM token in Supabase.
  Future<void> initialize(BuildContext context) async {
    Logger.start.log("Initializing the Firebase Messaging service...");

    await _instance.requestPermission();

    _message = await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    if (context.mounted) await _registerFCMTokenOnSupabase(context);
  }

  /// Retrieves the current FCM device token and registers it with Supabase, associating the token with the device's locale.
  ///
  /// Listens for token refresh events to update the token in Supabase automatically.
  Future<void> _registerFCMTokenOnSupabase(BuildContext context) async {
    final String? token = await _instance.getToken();
    late final Locale locale;
    
    if (token != null && context.mounted) {
      locale = Localizations.localeOf(context);
      await rSupabase.upsertFCMToken(token, locale);
    }
    
    _instance.onTokenRefresh.listen((newToken) async {
      await rSupabase.upsertFCMToken(newToken, locale);
    });
  }

  /// Handles any pending notification message and redirects to the appropriate screen.
  ///
  /// If no pending message exists or an error occurs during processing, the user is redirected to the default screen.
  void handlePendingNotification(BuildContext context) {
    try {
      if (_message == null) {
        Logger.information.log("There's no notification message to handle, opening the default Search view.");

        context.gtSearch(
          replace: true,
        );

        return;
      }

      final Map<String, dynamic> data = _message!.data;
      final String? title = data["Game-Title"];

      if (title != null) {
        final Game game = rHive.boxGames.fromTitle(title);

        if (context.mounted) {
          context.gtDetails(
            game: game,
            replace: true,
          );
        }
      }
    }
    catch (error, stackTrace) {
      Logger.error.log(
        "$error",
        stackTrace: stackTrace,
      );

      context.gtSearch(
        replace: true,
      );
    }
    finally {
      _message = null;
    }
  }
}