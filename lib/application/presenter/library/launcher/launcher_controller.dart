part of 'launcher_handler.dart';

/// A controller that manages the state of the launcher.
///
/// This controller is responsible for initializing the application.
class _Controller {
  
  _Controller({
    required this.activityService,
    required this.gitHub,
    required this.googleAuthentication,
    required this.hive,
    required this.supabase,
  });

  /// An instance of [GitHubService] that interacts with the GitHub API.
  ///
  /// This instance is used to fetch remote files and check for application updates.
  final GitHubService gitHub;

  /// An instance of [ActivityService] that manages native Android activity functions.
  ///
  /// This instance is used to interact with native Kotlin code and perform operations that are not available in Dart.
  final ActivityService activityService;

  /// An instance of [AuthenticationService] that manages Google authentication services.
  ///
  /// This instance is used to sign in and sign out users.
  final AuthenticationService googleAuthentication;

  /// An instance of [HiveRepository] that manages the local storage boxes for games, favorites, recent games, and cached requests.
  ///
  /// This instance is used to fetch and update the game collection from the GitHub repository, and store and retrieve game-related data.
  final HiveRepository hive;

  /// An instance of [SupabaseService] that manages the Supabase back-end services.
  ///
  /// This instance is used to log in users to Supabase and manage the application's data.
  final SupabaseService supabase;

  /// A notifier that manages the progress state throughout the application.
  /// 
  /// This [ValueNotifier] holds the current progress state, which can be one of the values from the [ProgressEnumeration] enum (e.g., login request, loading, success, error).
  final ValueNotifier<ProgressEnumeration> progressState = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.loading);

  /// Initializes the authentication services, application settings, and checks the user's locale.
  Future<void> initialize(BuildContext context) async {
    try {
      await hive.initialize();

      final String? userLocale = hive.settings.locale;

      final bool isOutdated = await gitHub.isVersionOutdated();

      if (isOutdated) {
        progressState.value = ProgressEnumeration.isOutdated;
      }
      else if (userLocale == null) {
        progressState.value = ProgressEnumeration.localeRequest;
      }
      else {
        await fetchAndAutheticateUser();
      }
    }
    catch (error, stackTrace) {
      progressState.value = ProgressEnumeration.error;
  
      Logger.error.print(
        message: '$error',
        label: 'Launcher Controller | Initialize',
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the MIDlet Store releases page on the web browser.
  ///
  /// This function is used to open the GitHub releases page for the MIDlet Store.
  Future<void> goToReleases() async => await activityService.openMidletStoreReleases();

  /// Sets the application's locale and persists the selection in Hive.
  void setLocale(Locale locale) => hive.settings.setLocale(locale.countryCode!); 

  /// Handles the authentication flow by attempting silent Google sign-in and logging the user into Supabase.
  ///
  /// The function first tries a silent Google sign-in.
  /// If successful, it logs the user into Supabase using the provided tokens.
  /// 
  /// Progress is tracked and updated using [progressState].
  Future<void> fetchAndAutheticateUser() async {
    progressState.value = ProgressEnumeration.loading;

    await supabase.initialize();

    await hive.fetchAndUpdateGameCollection();

    try {
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleAuthentication.signInSilently();
      
      if (googleSignInAuthentication != null) {
        // Perform Supabase login using Google authentication tokens.
        await supabase.loginWithGoogle(
          idToken: googleSignInAuthentication.idToken!,
          accessToken: googleSignInAuthentication.accessToken,
        );

        Logger.success.print(
          message: 'Successfully logged in Supabase.',
          label: 'Launcher Controller | Initialize',
        );

        progressState.value = ProgressEnumeration.finished;
      }
      else {
        // Update progress state to request login if silent sign-in fails.
        progressState.value = ProgressEnumeration.loginRequest;
      }
    }

    catch (error, stackTrace) {
      progressState.value = ProgressEnumeration.error;

      Logger.error.print(
        message: '$error',
        label: 'Launcher Controller | Initialize',
        stackTrace: stackTrace,
      );
    }
  }

  /// Performs the Google authentication process and logs the user into Supabase.
  /// 
  /// This method uses Google Sign-In to authenticate the user and then logs them into Supabase using the tokens provided.
  /// If the authentication is successful, the user is redirected to the `/search` screen.
  /// 
  /// Progress is tracked and updated using [progressState].
  Future<void> signIn(BuildContext context) async {
    try {
      final GoogleSignInAuthentication? authentication = await googleAuthentication.signIn();

      // If authentication is successful, proceed to Supabase login.
      if (authentication != null) {
        await supabase.loginWithGoogle(
          idToken: authentication.idToken!,
          accessToken: authentication.accessToken,
        );

        progressState.value = ProgressEnumeration.finished;
      }
    }
    catch (error, stackTrace) {
      progressState.value = ProgressEnumeration.error;

      Logger.error.print(
        message: error.toString(),
        label: 'Launcher Controller | Sign In',
        stackTrace: stackTrace,
      );
    }
  }
}