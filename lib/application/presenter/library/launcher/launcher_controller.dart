part of 'launcher_handler.dart';

/// The controller used to handle the [Launcher] state and data.
class _Controller {

  _Controller({
    required this.database,
  });

  /// The database service for data operations.
  late final IDatabase database;

  final ValueNotifier<String> message = ValueNotifier("");

  /// The [progress] listenable.
  /// 
  /// Used in the [Launcher] handler, it represents the current state of the view when initialized.
  final ValueNotifier<Progress> progress = ValueNotifier(Progress.loading);

  Future<void> initialize(BuildContext context) async {
    try {
      GoogleFonts.rajdhani();
      await GoogleFonts.pendingFonts();
      await database.initialize();

      if (context.mounted) {
        context.pushReplacement('/home');
      }

      progress.value = Progress.finished;
    }
    on ClientException catch (error) {
      Logger.error.print(
        label: 'Launcher | Controller',
        message: '$error',
      );
      message.value = 'The server could not be reached.\nPlease check your internet connection or try again later.';
      progress.value = Progress.error;
    }
    on ResponseException catch (error) {
      if (error.statusCode == HttpStatus.notFound) {
        message.value = 'Sorry, the server is offline!\nPlease try again later.';
      }
      else {
        message.value = 'The server returned ${error.statusCode}.\nPlease try again later.';
      }
      progress.value = Progress.error;
    }
    catch (error, stackTrace) {
      Logger.error.print(
        label: 'Launcher | Controller',
        message: '$error',
        stackTrace: stackTrace,
      );
      message.value = 'Internal error!';
      progress.value = Progress.error;
    }
  }

  /// Discards the resources used by the controller.
  /// 
  /// This method should be called when the controller is no longer needed to free up resources.
  void dispose() {
    progress.dispose();
  }
}