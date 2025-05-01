import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application/repositories/bucket_repository.dart';
import '../application/repositories/hive_repository.dart';
import '../application/repositories/supabase_repository.dart';

import '../application/services/activity_service.dart';
import '../application/services/admob_service.dart';
import '../application/services/android_service.dart';
import '../application/services/authentication_service.dart';
import '../application/services/github_service.dart';
import '../application/services/supabase_service.dart';

import '../application.dart';

void main() {

  // =========================================================================================================================================================================== //
  // MARK: Services:

  final ActivityService sActivity = ActivityService();
  final AdMobService sAdMob = AdMobService(const String.fromEnvironment("ADVERTISEMENT_UNIT_ID"));
  final AndroidService sAndroid = AndroidService();

  final GitHubService sGitHub = GitHubService(
    client: http.Client(),
    token: const String.fromEnvironment("GITHUB_BUCKET_TOKEN"),
  );

  final SupabaseService sSupabase = SupabaseService(
    anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
    url: const String.fromEnvironment("SUPABASE_URL"),
  );

  final GoogleOAuthService sGoogleOAuth = GoogleOAuthService(const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'));

  // =========================================================================================================================================================================== //
  // MARK: Repositories:

  final BucketRepository rBucket = BucketRepository(
    sAndroid: sAndroid,
    sGitHub: sGitHub,
  );

  final HiveRepository rHive = HiveRepository(sGitHub);
  final SupabaseRepository rSupabase = SupabaseRepository(sSupabase);

  runApp(MultiProvider(
    providers: <SingleChildWidget> [
      Provider<ActivityService>.value(
        value: sActivity,
      ),
      Provider<AdMobService>.value(
        value: sAdMob,
      ),
      Provider<GoogleOAuthService>.value(
        value: sGoogleOAuth,
      ),
      Provider<BucketRepository>.value(
        value: rBucket,
      ),
      Provider<GitHubService>.value(
        value: sGitHub,
      ),
      Provider<HiveRepository>.value(
        value: rHive,
      ),
      Provider<SupabaseService>.value(
        value: sSupabase,
      ),
      Provider<SupabaseRepository>.value(
        value: rSupabase,
      ),
    ],
    child: Application(),
  ));
}