part of '../installation/installation_handler.dart';

class _Controller {

  /// The Java ME application (MIDlet) object.
  final MIDlet midlet;

  /// Manages cloud storage operations, including downloading and caching assets such as game previews and thumbnails.
  final BucketRepository rBucket;

  /// Provides access to native Android activity functions, such as opening URLs or interacting with platform features.
  final ActivityService sActivity;

  /// Manages AdMob advertising operations, includingloading, displaying, and disposing of banner and interstitial advertisements.
  final AdMobService sAdMob;

  _Controller({
    required this.midlet,
    required this.rBucket,
    required this.sAdMob,
    required this.sActivity,
  });

  late final ValueNotifier<Emulators> nEmulator;

  late final ValueNotifier<ProgressEnumeration> nInstallationState;

  File? _file;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    nEmulator = ValueNotifier<Emulators>(Emulators.j2meLoader);
    nInstallationState = ValueNotifier<ProgressEnumeration>(ProgressEnumeration.isLoading);
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nEmulator.dispose();
    nInstallationState.dispose();
  }

  /// Downloads the MIDlet from the bucket.
  ///
  /// This function is used to download the selected MIDlet from the bucket.
  /// It updates the [nInstallationState] based on the result of the download operation.
  Future<void> downloadMIDlet(BuildContext context) async {
    Logger.information("Started downloading the MIDlet \"${midlet.file}\"...");

    try {
      _file = await rBucket.midlet(midlet);

      if (context.mounted) await _tryInstallMIDlet(context);
    }
    catch (error, stackTrace) {
      nInstallationState.value = ProgressEnumeration.hasError;

      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
  }

  /// Installs the downloaded MIDlet using the current selected emulator.
  Future<void> _tryInstallMIDlet(BuildContext context) async {
    try {
      if (_file == null) throw Exception("This MIDlet is not available!");

      await sActivity.emulator(_file!, nEmulator.value);

      if (context.mounted) context.pop();
    }
    on PlatformException catch (error, stackTrace) {
      nInstallationState.value = ProgressEnumeration.requestEmulator;

      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
    catch (error, stackTrace) {
      nInstallationState.value = ProgressEnumeration.hasError;

      Logger.error(
        '$error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> launchSourceUrl(BuildContext context) async {
    try {
      await sActivity.url(midlet.source);

      if (context.mounted) context.pop();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the emulator’s GitHub or Play Store page using a URL.
  Future<void> launchEmulatorPage(BuildContext context, String link) async {
    try {
      await sActivity.url(link);

      if (context.mounted) context.pop();
    }
    catch (error, stackTrace) {
      Logger.error(
        "$error",
        stackTrace: stackTrace,
      );

      nInstallationState.value = ProgressEnumeration.hasError;
    }
  }
}