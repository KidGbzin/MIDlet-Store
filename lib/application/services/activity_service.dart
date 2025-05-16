import 'dart:io';

import 'package:flutter/services.dart';

/// The [ActivityService] class handles the Android channels and activities.
/// 
/// This service provides platform-specific functionality for interacting with the Android operating system.
/// It is used to launch specific activities, such as the emulator activity, and open web pages in the default browser.
/// 
/// The implementation details can be found in [MainActivity.kt].
class ActivityService {

  /// The main Activity channel.
  static const MethodChannel _channel = MethodChannel("br.dev.kidgbzin.midlet_store");

  /// Installs the MIDlet file on the emulator.
  /// 
  /// Throws:
  /// - `PlatformException`: Thrown by the [MethodChannel] when the emulator activity is not found or unavailable.
  Future<void> emulator(File file) async {
    final Map<String, String> arguments = <String, String> {
      "Activity": "ru.playsoftware.j2meloader.MainActivity",
      "File-Path": file.path,
      "Package": "ru.playsoftware.j2meloader",
    };

    await _channel.invokeMethod('Install', arguments);
  }

  /// Opens the GitHub repository of the emulator on the web browser.
  Future<void> gitHub() async {
    final Map<String, String> arguments = <String, String> {
      "URL": "https://github.com/nikita36078/J2ME-Loader",
    };

    await _channel.invokeMethod('Launch URL', arguments);
  } 

  /// Opens the MIDlet Store releases page on the web browser.
  Future<void> openMIDletStoreReleases() async {
    final Map<String, String> arguments = <String, String> {
      "URL": "https://github.com/KidGbzin/MIDlet-Store/releases",
    };

    await _channel.invokeMethod('Launch URL', arguments);
  }

  /// Opens the PlayStore page of the emulator.
  Future<void> playStore() async {
    final Map<String, String> arguments = <String, String> {
      "URL": "market://details?id=ru.playsoftware.j2meloader",
    };

    await _channel.invokeMethod('Launch URL', arguments);
  } 
}
