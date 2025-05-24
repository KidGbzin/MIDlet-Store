part of '../midlets/midlets_handler.dart';

class _Controller {

  /// Cover image file associated with the current game.
  final File cover;

  /// List of MIDlet objects to be managed and displayed.
  final List<MIDlet> midlets;

  /// Manages AdMob advertising operations, including loading, displaying, and disposing of banner and interstitial advertisementss.
  final AdMobService sAdMob;

  _Controller({
    required this.cover,
    required this.midlets,
    required this.sAdMob,
  });

  late final ValueNotifier<int> nMIDletsLength;

  /// Initializes the handler’s core services and state notifiers.
  ///
  /// This method must be called from the `initState` of the handler widget.
  /// It prepares essential services and, if necessary, manages the initial navigation flow based on the current application state.
  Future<void> initialize() async {
    nMIDletsLength = ValueNotifier<int>(midlets.length);
  }

  /// Disposes the handler’s resources and notifiers.
  ///
  /// This method must be called from the `dispose` method of the handler widget to ensure proper cleanup and prevent memory leaks.
  void dispose() {
    nMIDletsLength.dispose();
  }
}