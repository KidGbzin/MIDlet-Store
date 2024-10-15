/// The entity responsible for the .JAR file information.
class MIDlet {

  MIDlet({
    required this.brand,
    required this.file,
    required this.languages,
    required this.resolution,
    required this.size,
    required this.title,
    required this.touchscreen,
    required this.version,
  });

  /// The phone brand that this [MIDlet] was made for.
  final String brand;

  /// Is the name of the [MIDlet] file with the extension .JAR.
  final String file;

  /// A list of all languages codes supported from the [MIDlet] file.
  final List<String> languages;

  /// It's the resolution of the game in pixels.
  final String resolution;

  /// The package size in kilobytes.
  final int size;

  /// Self-explanatory, just the game's title.
  final String title;

  /// A boolean to show if the [MIDlet] supports touchscreen input.
  final bool touchscreen;

  /// The [MIDlet] release version.
  final String version;

  /// Convert a JSON into a [MIDlet] object.
  /// 
  /// The parameter [json] is the JSON dynamic object to be converted into a [MIDlet].
  factory MIDlet.fromJson(dynamic json) {
    return MIDlet(
      brand: json['brand'] as String,
      file: json['file'] as String,
      languages: List<String>.from(json["languages"].map((element) => element)),
      resolution: json['resolution'] as String,
      size: json['size'] as int,
      title: json['title'] as String,
      touchscreen: json['touchscreen'] as bool,
      version: json['version'] as String,
    );
  }

  /// Export the [MIDlet] object to a JSON string.
  /// 
  /// This method is required to Hive write and read the object's data.
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'brand': brand,
      'file': file,
      'languages': languages,
      'resolution': resolution,
      'size': size,
      'title': title,
      'touchscreen': touchscreen,
      'version': version,
    };
  }
}