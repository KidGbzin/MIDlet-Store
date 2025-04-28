import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application/repositories/bucket_repository.dart';
import '../application/repositories/hive_repository.dart';
import '../application/repositories/supabase_repository.dart';

import '../application/services/activity_service.dart';
import '../application/services/android_service.dart';
import '../application/services/authentication_service.dart';
import '../application/services/github_service.dart';
import '../application/services/supabase_service.dart';

import '../application.dart';

// MAIN FUNCTION 🚀: ============================================================================================================================================================ //

/// The main entry point of the application.
/// 
/// Initializes all the necessary services and repositories that the application needs to function correctly, and then starts the Flutter framework.
/// This function is responsible for setting up the application's dependency injection, which includes services and repositories.
/// All the services and repositories are initialized here, and then the [Application] root widget is started.
void main() {

  // SERVICE INSTANCES 🔧: ====================================================================================================================================================== //

  /// Service responsible for handling Android I/O operations.
  ///
  /// Acts as a dependency for the Bucket service.
  final AndroidService sAndroid = AndroidService();

  /// Service responsible for user authentication with Google.
  final GoogleOAuthService sGoogleOAuth = GoogleOAuthService(const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'));

  /// Service for managing GitHub repository files.
  ///
  /// Handles the file operations and serves as a dependency for Hive and Bucket repositories.
  final GitHubService sGitHub = GitHubService(
    client: http.Client(),
    token: const String.fromEnvironment("GITHUB_BUCKET_TOKEN"),
  );

  /// Service for interacting with the Supabase back-end.
  ///
  /// Handles data operations and can be accessed via Provider injection.
  final SupabaseService sSupabase = SupabaseService(
    anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
    url: const String.fromEnvironment("SUPABASE_URL"),
  );

  /// Service for handling Android native activity functions.
  ///
  /// Uses method calls to interact with native Kotlin features and can be accessed via Provider injection.
  final ActivityService sActivity = ActivityService();

  // REPOSITORY INSTANCES 🗃️: =================================================================================================================================================== //

  /// Repository for managing application files.
  ///
  /// Handles application files and can be accessed globally via Provider injection.
  /// Depends on Android and GitHub services.
  final BucketRepository rBucket = BucketRepository(
    sAndroid: sAndroid,
    sGitHub: sGitHub,
  );

  /// Repository for local database management.
  ///
  /// Manages the application's cache and depends on the GitHub service.
  /// Can be accessed globally via Provider injection.
  final HiveRepository rHive = HiveRepository(sGitHub);

  /// Repository for interacting with the Supabase database server.
  ///
  /// Handles Supabase operations and depends on the Supabase service.
  /// Can be accessed globally via Provider injection.
  final SupabaseRepository rSupabase = SupabaseRepository(sSupabase);

  /// Starts the application using the Provider for dependency injection.
  /// 
  /// These values can be accessed throughout the application.
  runApp(MultiProvider(
    providers: <SingleChildWidget> [
      Provider<ActivityService>.value(
        value: sActivity,
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