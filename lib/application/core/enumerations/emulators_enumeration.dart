import 'dart:ui';

/// Enumeration representing supported J2ME emulators with their associated metadata.
enum Emulators {

  /// J2ME Loader by [Nikita Shakarun](https://github.com/nikita36078).
  /// 
  /// A popular open-source J2ME emulator for Android.
  j2meLoader(
    activity: "ru.playsoftware.j2meloader.MainActivity",
    assetImage: "assets/brands/J2ME-Loader.png",
    gitHub: "https://github.com/nikita36078/J2ME-Loader",
    package: "ru.playsoftware.j2meloader",
    playStore: "market://details?id=ru.playsoftware.j2meloader",
    primaryColor: Color(0xff525aa0),
    title: "J2ME Loader",
  ),

  /// JL-Mod by [woesss](https://github.com/woesss).
  /// 
  /// A modified fork of J2ME Loader with additional features.
  jlMod(
    activity: "ru.woesss.j2meloader.MainActivity",
    assetImage: "assets/brands/JL-Mod.png",
    gitHub: "https://github.com/woesss/JL-Mod",
    package: "ru.woesss.j2meloader",
    primaryColor: Color(0xff4b8a99),
    title: "JL-Mod",
  );

  /// The Android activity to launch for the emulator.
  final String activity;

  /// The asset image representing the emulator's brand or logo.
  final String assetImage;

  /// GitHub repository URL for the emulator's source code.
  final String gitHub;

  /// Android package name of the emulator.
  final String package;

  /// Play Store link to the emulator, if available.
  final String? playStore;

  /// Primary color used for UI theming or branding.
  final Color primaryColor;

  /// Display title of the emulator.
  final String title;

  const Emulators({
    required this.activity,
    required this.assetImage,
    required this.gitHub,
    required this.package,
    this.playStore,
    required this.primaryColor,
    required this.title,
  });
}