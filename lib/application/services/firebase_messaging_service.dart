import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../repositories/supabase_repository.dart';

import '../../logger.dart';

/// A service class responsible for managing Firebase Cloud Messaging (FCM) functionality.
///
/// This class leverages the [firebase_messaging](https://pub.dev/packages/firebase_messaging) package to request notification permissions and handle the FCM setup process.
/// It also processes incoming messages when the application is in the foreground, background, or terminated state, and manages the lifecycle of the FCM token as needed.
class FirebaseMessagingService {

  /// Manages remote storage operations through Supabase, including database interactions and data synchronization.
  final SupabaseRepository rSupabase;

  FirebaseMessagingService(this.rSupabase);

  final FirebaseMessaging _instance = FirebaseMessaging.instance;

  RemoteMessage? _message;

  RemoteMessage? get message => _message;

  /// Initializes the Firebase Cloud Messaging (FCM) service.
  ///
  /// Should be called on application startup (e.g., in the `Launcher`).
  /// It requests notification permissions, handles initial messages (if the app was terminated), sets up listeners for message events, and registers the FCM token in Supabase.
  Future<void> initialize(BuildContext context) async {
    Logger.start("Initializing the Firebase Messaging service...");

    await _instance.requestPermission();

    _message = await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  /// Retrieves the current FCM device token and registers it with Supabase, associating the token with the device's locale.
  ///
  /// Listens for token refresh events to update the token in Supabase automatically.
  Future<void> registerToken() async {
    final String? token = await _instance.getToken();
    
    if (token != null) {
      await rSupabase.upsertFirebaseToken(token);
    }
    
    _instance.onTokenRefresh.listen((newToken) async {
      await rSupabase.upsertFirebaseToken(newToken);
    });
  }


  void clearNotificationMessage() {
    Logger.information("The notification message has been cleared!");

    _message == null;
  }
}