part of 'launcher_handler.dart';

/// The controller used to handle the [Launcher] state and data.
class _Controller {

  _Controller({
    required this.authentication,
    required this.database,
  });

  /// The database service for data operations.
  final IDatabase database;

  final IAuthentication authentication;

  late final String message;
  late final ValueNotifier<Progress> progress = ValueNotifier<Progress>(Progress.loading);

  Future<void> login(BuildContext context) async {
    try {
      await authentication.login();

      if (context.mounted) {
        context.pushReplacement('/home');
      }
    }
    catch (_) {
      final Messenger messenger = Messenger(
        message: 'Oops, we couldn\'t sign you in with your Google account. Please try again.',
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(messenger);
      }
    }
  }

  Future<void> initialize(BuildContext context) async {
    final GoogleSignInAccount? account;

    try {
      GoogleFonts.rajdhani();
      await GoogleFonts.pendingFonts();
      await database.initialize();
      account = await authentication.currentAccount();

      if (account != null && context.mounted) {
        context.pushReplacement('/home');
      }
      else {
        progress.value = Progress.finished;
      }
    }
    on ClientException catch (error) {
      progress.value = Progress.error;
      Logger.error.print(
        label: 'Launcher | Controller',
        message: '$error',
      );
      message = 'The server could not be reached.\nPlease check your internet connection or try again later.';
    }
    on ResponseException catch (error) {
      progress.value = Progress.error;
      if (error.statusCode == HttpStatus.notFound) {
        message = 'Sorry, the server is offline!\nPlease try again later.';
      }
      else {
        message = 'The server returned ${error.statusCode}.\nPlease try again later.';
      }
    }
    catch (error, stackTrace) {
      progress.value = Progress.error;
      Logger.error.print(
        label: 'Launcher | Controller',
        message: '$error',
        stackTrace: stackTrace,
      );
      message = 'Internal error!';
    }
  }

  void dispose() {
    progress.dispose();
  }
}