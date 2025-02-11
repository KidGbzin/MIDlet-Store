import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/enumerations/logger_enumeration.dart';

/// Service for interacting with the GitHub API to fetch remote files.
///  
/// This service retrieves external game data stored in a private GitHub repository, which is used as a file storage solution (bucket) to reduce infrastructure costs.
/// GitHub provides rate-limited file requests that reset every hour, making it a viable alternative to traditional cloud storage services.  
/// 
/// Utilizes the [`http`](https://pub.dev/packages/http) package for making network requests.
class GitHubService {

  GitHubService(this.client);

  final http.Client client;

  /// The headers for the GitHub API requests.
  ///
  /// If a request lacks headers, the API returns an error 403 (forbidden access).
  /// All requests made on the GitHub return a raw MIME type.
  final Map<String, String> _headers = <String, String> {
    "Accept": "application/json",
    "Authorization": "token $_token",
    "Content-Type": "application/vnd.github.raw",
  };

  /// The key to access the GitHub API.
  ///
  /// All external game data is stored in a private repository and can only be accessed via a token.
  /// If the provided token is incorrect or does not exist, an error [HttpStatus.notFound] will be returned.
  static const String _token = String.fromEnvironment("GITHUB_BUCKET_TOKEN");

  /// Fetches a file from the GitHub API as a [Uint8List].
  ///
  /// Throws:
  /// - `ClientException`: Thrown by the [`http`](https://pub.dev/packages/http) package, usually when there is no connection available.
  Future<Uint8List?> get(String source) async {
    http.Response response = await client.get(
      Uri.parse('https://raw.githubusercontent.com/KidGbzin/J2ME/bucket/files/$source'),
      headers: _headers,
    );
    if (response.statusCode == HttpStatus.ok) {
      Logger.success.print(
        label: 'GitHub | GET • ${response.statusCode}',
        message: 'The file "$source" was successfully fetched.',
      );
      return response.bodyBytes;
    }
    else {
      Logger.error.print(
        label: 'GitHub | GET • ${response.statusCode}',
        message: 'The file "$source" couldn\'t be fetched.',
      );
      return null;
    }
  }

  /// Checks if the current version of the application is outdated compared to the latest release in the GitHub repository.
  ///
  /// This method sends a GET request to the GitHub API to retrieve information about the latest release of the `MIDlet-Store` repository.
  /// It then compares the version of the latest release with the version of the currently running application.
  /// If the latest release has a higher version number, it returns `true`, indicating that the application is outdated.
  /// If the versions are the same, it returns `false`, indicating that the application is up to date.
  ///
  /// Throws:
  /// - `ClientException`: Thrown by the [`http`](https://pub.dev/packages/http) package, usually when there is no connection available.
  /// - `Exception`: Thrown if the latest release from the repository could not be found.
  Future<bool> isVersionOutdated() async {
    final http.Response response = await client.get(Uri.parse("https://api.github.com/repos/KidGbzin/MIDlet-Store/releases/latest"));

    if (response.statusCode != HttpStatus.ok) throw Exception("The latest release from the repository could not be found.");

    final String latestVersion = (jsonDecode(response.body)['tag_name'] as String).replaceFirst('v', "");
    final String packageVersion = await PackageInfo.fromPlatform().then((packageInfo) => packageInfo.version);

    final List<int> versionA = packageVersion.split('.').map(int.parse).toList();
    final List<int> versionB = latestVersion.split('.').map(int.parse).toList();

    for (int index = 0; index < versionA.length || index < versionB.length; index++) {
      int numberA = (index < versionA.length) ? versionA[index] : 0;
      int numberB = (index < versionB.length) ? versionB[index] : 0;

      if (numberA < numberB) return true;
      if (numberA > numberB) return false;
    }
    return false;
  }

  /// Fetches the last updated timestamp for the static database file in the GitHub repository. 
  /// 
  /// This function is designed to minimize traffic by checking if the static database file has been updated.
  /// It retrieves the `Last-Modified` timestamp of the `DATABASE.json` file from the GitHub repository's metadata.
  /// 
  /// Throws:
  /// - `ClientException`: Thrown by the [`http`](https://pub.dev/packages/http) package, usually when there is no connection available.
  Future<DateTime?> getLastUpdatedDate() async {
    http.Response response = await client.get(
      Uri.parse("https://api.github.com/repos/KidGbzin/J2ME/contents/files/DATABASE.json"),
      headers: _headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      String? lastUpdated = response.headers["last-modified"];

      if (lastUpdated != null) {
        lastUpdated = lastUpdated.split(',')[1].trim();
        final DateTime dateTime = DateFormat("dd MMM yyyy HH:mm:ss 'GMT'").parse(lastUpdated);

        return dateTime;
      }

      Logger.error.print(
        label: "GitHub | Last Updated Database",
        message: "Failed to retrieve the latest modification timestamp from the database file.",
      );

      return null;
    }
    else {
      Logger.error.print(
        label: "GitHub | GET • ${response.statusCode}",
        message: "Database file not found.",
      );
      return null;
    }
  }
}