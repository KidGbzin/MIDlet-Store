import '../configuration/global_configuration.dart';

/// Represents a Java ME (J2ME) application, typically distributed as a `.jar` file.
///
/// A [MIDlet] contains metadata and attributes describing the mobile Java application, including device compatibility,
/// display settings, multiplayer support, localization, and technical requirements.
///
/// This class is used for storing, displaying, and managing Java ME games within the application context.
class MIDlet {

  // MARK: Constructor ⮟

  /// The target phone brand for which this MIDlet was designed.
  final String brand;

  /// The filename of the MIDlet JAR package, including the `.jar` extension.
  final String file;

  /// Whether the MIDlet contains censored or restricted content.
  final bool isCensored;

  /// Whether the MIDlet is a default (pre-installed) application.
  final bool isDefault;

  /// Whether the MIDlet is optimized for landscape orientation.
  final bool isLandscape;

  /// Whether the MIDlet supports Bluetooth multiplayer.
  final bool isMultiplayerB;

  /// Whether the MIDlet supports local (offline) multiplayer.
  final bool isMultiplayerL;

  /// Whether the MIDlet adapts to multiple screen resolutions.
  final bool isMultiscreen;

  /// Whether the MIDlet requires an internet connection.
  final bool isOnline;

  /// Whether the MIDlet supports touchscreen input.
  final bool isTouchscreen;

  /// Whether the MIDlet features 3D graphics.
  final bool isThreeD;

  /// Supported language codes for localization.
  final List<String> languages;

  /// The native screen resolution of the MIDlet.
  final String resolution;

  /// The size of the JAR package in kilobytes.
  final int size;

  /// The source from which the MIDlet was obtained.
  final String source;

  /// The title of the MIDlet.
  final String title;

  /// The release version of the MIDlet.
  final String version;

  MIDlet({
    required this.brand,
    required this.file,
    required this.isCensored,
    required this.isDefault,
    required this.isLandscape,
    required this.isMultiplayerB,
    required this.isMultiplayerL,
    required this.isMultiscreen,
    required this.isOnline,
    required this.isTouchscreen,
    required this.isThreeD,
    required this.languages,
    required this.resolution,
    required this.size,
    required this.source,
    required this.title,
    required this.version,
  });

  // MARK: Formats ⮟

  /// Returns the file size in kilobytes, rounded and formatted as a string (e.g., "512 KB").
  String get fSize => "${(size / 1024).round()} KB";

  /// Returns the screen resolution with spacing (e.g., "240x320" → "240 x 320").
  String get fResolution => resolution.replaceFirst("x", " x ");

  /// Returns the formatted title, replacing " -" with ":" (e.g., "Bomberman - Deluxe" → "Bomberman: Deluxe").
  String get fTitle => title.replaceFirst(" -", ":");

  // MARK: JSON Methods ⮟

  /// Creates a [MIDlet] instance from a JSON string.
  /// 
  /// The [jString] parameter is expected to be a dynamic object containing key-value pairs that map to the properties of this class.
  /// 
  /// Throws:
  /// - `FormatException`: Thrown when a required field is missing, null, or does not match the expected type during parsing.
  factory MIDlet.fromJson(dynamic jString) {
    return MIDlet(
      brand: require<String>(jString, "brand")!,
      file: require<String>(jString, "file")!,
      isCensored: require<bool>(jString, "isCensored")!,
      isDefault: require<bool>(jString, "isDefault")!,
      isLandscape: require<bool>(jString, "isLandscape")!,
      isMultiplayerB: require<bool>(jString, "isMultiplayerB")!,
      isMultiplayerL: require<bool>(jString, "isMultiplayerL")!,
      isMultiscreen: require<bool>(jString, "isMultiscreen")!,
      isOnline: require<bool>(jString, "isOnline")!,
      isTouchscreen: require<bool>(jString, "isTouchscreen")!,
      isThreeD: require<bool>(jString, "isThreeD")!,
      languages: require<List<String>>(jString, "languages")!,
      resolution: require<String>(jString, "resolution")!,
      size: require<int>(jString, "size")!,
      source: require<String>(jString, "source")!,
      title: require<String>(jString, "title")!,
      version: require<String>(jString, "version")!,
    );
  }

  /// Converts this [MIDlet] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'brand': brand,
      'file': file,
      'isCensored': isCensored,
      'isDefault': isDefault,
      'isLandscape': isLandscape,
      'isMultiplayerB': isMultiplayerB,
      'isMultiplayerL': isMultiplayerL,
      'isMultiscreen': isMultiscreen,
      'isOnline': isOnline,
      'isTouchscreen': isTouchscreen,
      'isThreeD': isThreeD,
      'languages': languages,
      'resolution': resolution,
      'size': size,
      'source': source,
      'title': title,
      'version': version,
    };
  }
}