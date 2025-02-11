import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../application.dart';

import '../application/repositories/bucket_repository.dart';
import '../application/repositories/database_repository.dart';
import '../application/repositories/hive_repository.dart';

import '../application/services/activity_service.dart';
import '../application/services/android_service.dart';
import '../application/services/authentication_service.dart';
import '../application/services/github_service.dart';
import '../application/services/supabase_service.dart';

void main() {

  // SERVICE INTANCES 🧩: ======================================================================================================================================================= //

  /// Service responsible for handling Android I/O operations.
  ///
  /// Acts as a dependency for the Bucket service.
  final AndroidService androidService = AndroidService();

  /// Service responsible for user authentication.
  final AuthenticationService authenticationService = AuthenticationService();

  /// Service for managing GitHub repository files.
  ///
  /// Handles the file operations and serves as a dependency for Hive and Bucket repositories.
  final GitHubService gitHubService = GitHubService(http.Client());

  /// Service for interacting with the Supabase back-end.
  ///
  /// Handles data operations and can be accessed via Provider injection.
  final SupabaseService supabaseService = SupabaseService();

  /// Service for handling Android native activity functions.
  ///
  /// Uses method calls to interact with native Kotlin features and can be accessed via Provider injection.
  final ActivityService activityService = ActivityService();

  // REPOSITORY INSTANCES 🧩: =================================================================================================================================================== //

  /// Repository for managing application files.
  ///
  /// Handles application files and can be accessed globally via Provider injection.
  /// Depends on Android and GitHub services.
  final BucketRepository bucketRepository = BucketRepository(
    android: androidService,
    gitHub: gitHubService,
  );

  /// Repository for local database management.
  ///
  /// Manages the application's cache and depends on the GitHub service.
  /// Can be accessed globally via Provider injection.
  final HiveRepository hiveRepository = HiveRepository(gitHubService);

  /// Repository for interacting with the Supabase database server.
  ///
  /// Handles Supabase operations and depends on the Supabase service.
  /// Can be accessed globally via Provider injection.
  final SupabaseRepository supabaseRepository = SupabaseRepository(supabaseService);

  // RUN APPLICATION 🧩: ======================================================================================================================================================== //

  /// Starts the application using the Provider for dependency injection.
  /// 
  /// These values can be accessed throughout the application.
  runApp(MultiProvider(
    providers: <SingleChildWidget> [
      Provider<ActivityService>.value(
        value: activityService,
      ),
      Provider<AuthenticationService>.value(
        value: authenticationService,
      ),
      Provider<BucketRepository>.value(
        value: bucketRepository,
      ),
      Provider<GitHubService>.value(
        value: gitHubService,
      ),
      Provider<HiveRepository>.value(
        value: hiveRepository,
      ),
      Provider<SupabaseService>.value(
        value: supabaseService,
      ),
      Provider<SupabaseRepository>.value(
        value: supabaseRepository,
      ),
    ],
    child: const Application(),
  ));
}