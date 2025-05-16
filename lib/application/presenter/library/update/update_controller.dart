part of '../update/update_handler.dart';

class _Controller {

  /// Provides access to native Android activity functions, such as opening URLs or interacting with platform features.
  final ActivityService sActivity;

  const _Controller({
    required this.sActivity,
  });

  /// Launches the GitHub releases page for the MIDlet Store project in the user's default browser.
  Future<void> openMIDletStoreReleases() async => await sActivity.openMIDletStoreReleases();
}