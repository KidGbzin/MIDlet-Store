import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Service for managing local data storage and retrieval within the application.
/// 
/// Handles interactions with the device's file system, including:
/// - **Asset Caching**: Stores and retrieves game previews, thumbnails, and other media files.
/// - **File Management**: Reads, writes, and organizes files in local storage.
/// 
/// Utilizes the [`path_provider`](https://pub.dev/packages/path_provider) package to access platform-specific directories.
class AndroidService {
  
  /// Read a file from the application's folder.
  Future<File> read({
    required String document,
    required String folder,
  }) async {
    final Directory? root = await getExternalStorageDirectory();
    final Directory directory = Directory('${root!.path}/$folder')..createSync(
      recursive: true,
    );
    final File file = File('${directory.path}/$document');
    return file;
  }

  /// Write a file on the application's folder.
  Future<File> write({
    required Uint8List bytes,
    required String document,
    required String folder,
  }) async {
    final Directory? root = await getExternalStorageDirectory();
    final Directory directory = Directory('${root!.path}/$folder')..createSync(
      recursive: true,
    );
    final File file = File('${directory.path}/$document');
    return file.writeAsBytes(bytes);
  }
}