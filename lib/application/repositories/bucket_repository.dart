import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../core/entities/midlet_entity.dart';

import '../services/android_service.dart';
import '../services/github_service.dart';

/// A repository class for managing file operations related to Android and GitHub storage.
///
/// This class manages file retrieval and handling, seamlessly integrating local Android storage and a GitHub repository to fetch cover images and preview files.
class BucketRepository {

  // MARK: Constructor ⮟

  /// The service responsible for managing Android I/O operations.
  final AndroidService sAndroid;

  /// The service responsible for interacting with the GitHub API.
  final GitHubService sGitHub;

  const BucketRepository({
    required this.sAndroid,
    required this.sGitHub,
  });

  // MARK: Audio ⮟

  /// Retrieves the audio theme for a game identified by the [title].
  /// 
  /// This method first checks if the audio theme file already exists locally in the `Audios` directory.
  /// If the file is found, it returns it directly.
  /// If not, it fetches the audio theme from the GitHub repository and caches it locally in the `Audios` folder for future use.
  ///
  /// Throws:
  /// - `Exception`: If the audio theme cannot be retrieved either locally or from GitHub.
  Future<File> audio(String title) async {
    const String folder = 'Audios';
    final String document = '$title.rtx';

    File file = await sAndroid.read(
      folder: folder,
      document: document,
    );

    final bool exists = await file.exists();

    if (!exists) {
      final Uint8List? bytes = await sGitHub.get('$folder/$document');

      if (bytes == null) throw Exception("Unable to retrieve the \"$title\" audio theme.");

      file = await sAndroid.write(
        bytes: bytes,
        document: document,
        folder: folder,
      );
    }

    return file;
  }

  // MARK: Cover ⮟

  /// Retrieves the cover image for a game identified by the [title].
  /// 
  /// This method first checks if the cover image file already exists locally in the `Covers` directory.
  /// If the file is found, it returns it directly.
  /// If not, it fetches the cover image from the GitHub repository and caches it locally in the `Covers` folder for future use.
  ///
  /// Throws:
  /// - `Exception`: If the cover image cannot be retrieved either locally or from GitHub.
  Future<File> cover(String title) async {
    const String folder = 'Covers';
    final String document = '$title.png';

    File file = await sAndroid.read(
      folder: folder,
      document: document,
    );

    final bool exists = await file.exists();

    if (!exists) {
      final Uint8List? bytes = await sGitHub.get('$folder/$document');

      if (bytes == null) throw Exception("Unable to retrieve the \"$title\" cover image.");

      file = await sAndroid.write(
        bytes: bytes,
        document: document,
        folder: folder,
      );
    }

    return file;
  }

  // MARK: MIDlet ⮟

  /// Retrieves a MIDlet file from the local storage or downloads it from the GitHub repository if it is not available locally.
  ///
  /// This method first checks if the MIDlet file is available locally in the `MIDlets/<title>` directory.
  /// If the file is not found, it fetches the MIDlet file from the GitHub repository and caches it locally for future use.
  ///
  /// Throws:
  /// - `Exception`: If the MIDlet file cannot be retrieved either locally or from GitHub.
  Future<File> midlet(MIDlet midlet) async {
    String title = midlet.title;
    
    if (midlet.title.endsWith(".")) title = "${title}_";

    final String folder = 'MIDlets/$title';

    File file = await sAndroid.read(
      folder: folder,
      document: midlet.file,
    );

    final bool exists = await file.exists();

    if (!exists) {
      final Uint8List? bytes = await sGitHub.get('$folder/${midlet.file}');

      if (bytes == null) throw Exception("Unable to retrieve the file \"${midlet.file}\".");

      file = await sAndroid.write(
        bytes: bytes,
        document: midlet.file,
        folder: folder,
      );
    }

    return file;
  }

  // MARK: Previews ⮟

  /// Retrieves preview images for a game identified by the [title].
  /// 
  /// This method first checks if the preview images, stored as a ZIP file, are available locally in the `Previews` directory.
  /// If the ZIP file is not found, it fetches the ZIP file containing the previews from the GitHub repository and caches it locally.
  /// Once the ZIP file is downloaded and stored, it is extracted, and the preview images are returned as a sorted list of [Uint8List] representing the image data.
  ///
  /// Exceptions to be handled:
  /// - `Exception`: If the preview images cannot be retrieved either locally or from GitHub.
  /// - `FormatException`: If the ZIP file cannot be extracted properly or the images within are not in the expected format.
  Future<List<Uint8List>> previews(String title) async {
    const String folder = 'Previews';
    final String document = '$title.zip';

    File file = await sAndroid.read(
      folder: folder,
      document: document,
    );

    final bool exists = await file.exists();

    if (!exists) {
      final Uint8List? bytes = await sGitHub.get('$folder/$document');

      if (bytes == null) throw Exception("Unable to retrieve the \"$title\" previews.");

      file = await sAndroid.write(
        bytes: bytes,
        document: document,
        folder: folder,
      );
    }

    return _extract(file);
  }

  /// Extracts the files from a .ZIP archive and returns them as a sorted list of [Uint8List].
  ///
  /// This function reads the content of a given ZIP [package], decodes its files, extracts the file contents (ignoring directories).
  /// The extracted files are sorted by their names in ascending order ("0.png", "1.png", "2.png").
  List<Uint8List> _extract(File package) {
    final List<Uint8List> temporary = <Uint8List>[];
    final Uint8List bytes = package.readAsBytesSync();
    final Archive archive = ZipDecoder().decodeBytes(bytes);

    final List<ArchiveFile> filesSorted = archive.files.where((file) => file.isFile).toList()..sort((x, y) => x.name.compareTo(y.name));

    for (ArchiveFile file in filesSorted) {
      temporary.add(file.content);
    }

    return temporary;
  }

  // MARK: Publisher ⮟

  /// Retrieves the publisher logo for a game identified by the [title].
  /// 
  /// This method first checks if the publisher logo file is available locally in the `Publisher` directory.
  /// If the file is not found, it fetches the logo from the GitHub repository and caches it locally.
  /// The retrieved logo is returned as a [File] object.
  ///
  /// Throws:
  /// - `Exception`: If the logo cannot be retrieved either locally or from GitHub.
  Future<File> publisher(String title) async {
    const String folder = 'Publishers';
    final String document = '$title.png';

    File file = await sAndroid.read(
      folder: folder,
      document: document,
    );

    final bool exists = await file.exists();

    if (!exists) {
      final Uint8List? bytes = await sGitHub.get('$folder/$document');

      if (bytes == null) throw Exception("Unable to retrieve the \"$title\" logo.");

      file = await sAndroid.write(
        bytes: bytes,
        document: document,
        folder: folder,
      );
    }
    
    return file;
  }
}