part of '../settings/settings_handler.dart';

class _Controller implements IController {

  _Controller();

  @override
  void dispose() {
    nProgress.dispose();
  }

  @override
  Future<void> initialize() async {}

  // MARK: -------------------------
  // 
  // 
  // 
  // MARK: Notifiers ⮟

  final ValueNotifier<({
    Progresses state,
    Object? error,
  })> nProgress = ValueNotifier((
    error: null,
    state: Progresses.isLoading,
  ));
}