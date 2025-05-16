import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application/core/enumerations/logger_enumeration.dart';

import '../application/repositories/bucket_repository.dart';
import '../application/repositories/hive_repository.dart';
import '../application/repositories/supabase_repository.dart';

import '../application/services/activity_service.dart';
import '../application/services/admob_service.dart';
import '../application/services/android_service.dart';
import '../application/services/authentication_service.dart';
import '../application/services/firebase_messaging_service.dart';
import '../application/services/github_service.dart';
import '../application/services/supabase_service.dart';

import '../application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.start.log("Initializing the Firebase enviroment...");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: const String.fromEnvironment("GOOGLE_API_KEY"),
      appId: "1:923401966131:android:74b789539ded6e8e55c946",
      messagingSenderId: "923401966131",
      projectId: "midlet-store-52168",
      storageBucket: "midlet-store-52168.firebasestorage.app",
    ),
  );

  final ActivityService sActivity = ActivityService();
  final AdMobService sAdMob = AdMobService(const String.fromEnvironment("ADVERTISEMENT_UNIT_ID"));
  final AndroidService sAndroid = AndroidService();

  final GitHubService sGitHub = GitHubService(
    client: http.Client(),
    token: const String.fromEnvironment("GITHUB_BUCKET_TOKEN"),
  );

  final SupabaseService sSupabase = SupabaseService(
    anonKey: const String.fromEnvironment("SUPABASE_KEY"),
    url: const String.fromEnvironment("SUPABASE_URL"),
  );

  final GoogleOAuthService sGoogleOAuth = GoogleOAuthService(const String.fromEnvironment('GOOGLE_SERVER_CLIENT'));

  final BucketRepository rBucket = BucketRepository(
    sAndroid: sAndroid,
    sGitHub: sGitHub,
  );

  final HiveRepository rHive = HiveRepository(sGitHub);
  final SupabaseRepository rSupabase = SupabaseRepository(sSupabase);

  final FirebaseMessagingService sFirebaseMessaging = FirebaseMessagingService(
    rSupabase: rSupabase,
    rHive: rHive,
  );

  runApp(MultiProvider(
    providers: <SingleChildWidget> [
      Provider<ActivityService>.value(
        value: sActivity,
      ),
      Provider<AdMobService>.value(
        value: sAdMob,
      ),
      Provider<FirebaseMessagingService>.value(
        value: sFirebaseMessaging,
      ),
      Provider<GoogleOAuthService>.value(
        value: sGoogleOAuth,
      ),
      Provider<GitHubService>.value(
        value: sGitHub,
      ),
      Provider<SupabaseService>.value(
        value: sSupabase,
      ),
      Provider<BucketRepository>.value(
        value: rBucket,
      ),
      Provider<HiveRepository>.value(
        value: rHive,
      ),
      Provider<SupabaseRepository>.value(
        value: rSupabase,
      ),
    ],
    child: Application(),
  ));
}