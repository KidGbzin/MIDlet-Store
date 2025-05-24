// MIDLET ENTITY ☕️: ============================================================================================================================================================ //

/// Represents a Java ME (J2ME) application entity, which is a `.jar` file containing a mobile Java application.
///
/// The `MIDlet` entity provides metadata and attributes related to the Java ME application, such as the brand, file, censoring, default, landscape, multiplayer, and tags.
class MIDlet {

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
    required this.title,
    required this.version,
  });

  /// The target phone brand for which this [MIDlet] was designed.
  final String brand;

  /// The filename of the [MIDlet] JAR package, including the `.jar` extension.
  final String file;

  /// Indicates whether the [MIDlet] contains censored or restricted content.
  final bool isCensored;

  /// Specifies if this [MIDlet] is a default (pre-installed) application.
  final bool isDefault;

  /// Determines if the [MIDlet] is optimized for landscape orientation.
  final bool isLandscape;

  /// Specifies if the [MIDlet] supports Bluetooth multiplayer functionality.
  final bool isMultiplayerB;

  /// Specifies if the [MIDlet] supports Local multiplayer functionality.
  final bool isMultiplayerL;

  /// Indicates if the [MIDlet] can adapt to multiple screen resolutions.
  final bool isMultiscreen;

  /// Determines whether the [MIDlet] requires an internet connection.
  final bool isOnline;

  /// Indicates if the [MIDlet] supports touchscreen input.
  final bool isTouchscreen;

  /// Specifies whether the [MIDlet] features 3D graphics.
  final bool isThreeD;

  /// A list of supported language codes for localization.
  final List<String> languages;

  /// The native screen resolution of the [MIDlet] in pixels.
  final String resolution;

  /// The size of the .JAR package in kilobytes.
  final int size;

  /// The title of the [MIDlet].
  final String title;

  /// The release version of the [MIDlet].
  final String version;

  /// Creates a [MIDlet] instance from a JSON object.
  /// 
  /// The [json] parameter is expected to be a dynamic object containing
  /// key-value pairs that map to the properties of this class.
  factory MIDlet.fromJson(dynamic json) {
    return MIDlet(
      brand: json['brand'] as String,
      file: json['file'] as String,
      isCensored: json['isCensored'] as bool,
      isDefault: json['isDefault'] as bool,
      isLandscape: json['isLandscape'] as bool,
      isMultiplayerB: json['isMultiplayerB'] as bool,
      isMultiplayerL: json['isMultiplayerL'] as bool,
      isMultiscreen: json['isMultiscreen'] as bool,
      isOnline: json['isOnline'] as bool,
      isTouchscreen: json['isTouchscreen'] as bool,
      isThreeD: json['isThreeD'] as bool,
      languages: List<String>.from(json["languages"]),
      resolution: json['resolution'] as String,
      size: json['size'] as int,
      title: json['title'] as String,
      version: json['version'] as String,
    );
  }

  /// Converts the [MIDlet] instance into a JSON-compatible map.
  /// 
  /// This method is primarily used for serialization, including storage and data transmission.
  Map<String, dynamic> toJson() {
    return {
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
      'title': title,
      'version': version,
    };
  }

  String get formattedSize => "${(size / 1024).round()} KB";

  String get formattedResolution => resolution.replaceFirst("x", " x ");
}