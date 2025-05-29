import 'dart:io';

import 'package:flutter/services.dart';

import '../core/enumerations/emulators_enumeration.dart';

/// This service provides platform-specific functionality for interacting with the Android operating system.
/// It is used to launch specific activities, such as the emulator activity, and open web pages in the default browser.
/// 
/// The implementation details can be found in [MainActivity.kt].
class ActivityService {

  static const MethodChannel _channel = MethodChannel("br.dev.kidgbzin.midlet_store");

  /// Installs the MIDlet file on the emulator.
  /// 
  /// Throws:
  /// - `PlatformException`: Thrown by the [MethodChannel] when the emulator activity is not found or unavailable.
  Future<void> emulator(File file, Emulators emulator) async {
    final Map<String, String> arguments = <String, String> {
      "Activity": emulator.activity,
      "File-Path": file.path,
      "Package": emulator.package,
    };

    await _channel.invokeMethod('Install', arguments);
  }

  /// Launches the specified URL using a platform-specific method.
  ///
  /// This method sends the URL to the native platform via [MethodChannel] to open it in a browser or handler application.
  ///
  /// Throws:
  /// - `PlatformException`: If the platform fails to handle the URL launch.
  Future<void> url(String url) async {
    final Map<String, String> arguments = <String, String> {
      "URL": url,
    };

    await _channel.invokeMethod('Launch URL', arguments);
  }
}