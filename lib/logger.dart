import 'dart:developer' as dart;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// A singleton class for logging custom messages to a file and the console, with support for multiple log levels (error, success, info, etc.).
///
/// This logger writes messages with timestamps, emojis, and colors to the console, and also logs them to a `LOG.txt` file in the device's external storage directory.
/// It is useful for tracking and debugging application behavior more effectively.
class Logger {

  Logger._internal();

  static final Logger _instance = Logger._internal();

  factory Logger() => _instance;

  /// The output sink that writes log entries to the file.
  static late IOSink _sink;

  /// Initializes the logger by creating or resetting the log file.
  ///
  /// This method must be called before using the logger.
  /// It creates (or overwrites) a `LOG.txt` file in the external storage directory, and prepares it for writing.
  static Future<void> initialize() async {
    final Directory? directory = await getExternalStorageDirectory();
    final File file = File('${directory!.path}/LOG.txt');

    if (file.existsSync()) file.deleteSync();

    file.createSync();

    _sink = file.openWrite(
      mode: FileMode.append,
    );
  }

  static void error(String message, {StackTrace? stackTrace}) => _log(message, "31", "❌", stackTrace);
  static void information(String message, {StackTrace? stackTrace}) => _log(message, "36", "📣", stackTrace);
  static void start(String message, {StackTrace? stackTrace}) => _log(message, "36", "🚀", stackTrace);
  static void success(String message, {StackTrace? stackTrace}) => _log(message, "32", "✅", stackTrace);
  static void trash(String message, {StackTrace? stackTrace}) => _log(message, "35", "🗑️", stackTrace);
  static void warning(String message, {StackTrace? stackTrace}) => _log(message, "33", "📢", stackTrace);

  /// Internal method that handles message formatting and output.
  ///
  /// Applies color formatting using ANSI codes and writes to both the console and the log file. Each log entry includes:
  /// - A timestamp;
  /// - The originating file (caller);
  /// - The log message;
  /// - An optional stack trace.
  ///
  /// The parameter [code] is the ANSI color code for the console output:
  /// - 30: Black;
  /// - 31: Red;
  /// - 32: Green;
  /// - 33: Yellow;
  /// - 34: Blue;
  /// - 35: Purple;
  /// - 36: Cyan;
  /// - 37: White.
  static void _log(String message, String code, String emoji, StackTrace? stackTrace) {
    final String timestamp = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    final String caller = _caller(StackTrace.current).toUpperCase();
    final String stack = stackTrace == null ? "" : "\n$stackTrace";
    final String text = "[ $timestamp | ${caller.toUpperCase()} ] : $message$stack";

    dart.log(
      ": \x1b[${code}m$emoji $message\x1B[0m",
      name: " $timestamp ",
      stackTrace: stackTrace,
    );

    _sink.writeln(text);
  }

  /// Extracts the file name of the caller from the [StackTrace].
  ///
  /// This method parses the current stack trace and skips internal frames related to the logger itself or Dart runtime suspensions.
  /// Returns the file name (e.g., `main.dart`) where the log call originated.
  static String _caller(StackTrace stackTrace) {
    final List<String> frames = stackTrace.toString().split('\n');

    for (String frame in frames) {
      if (frame.contains("logger.dart")) continue;
      if (frame.contains('<asynchronous suspension>')) continue;

      final RegExp regex = RegExp(r'\((.+?):(\d+):(\d+)\)');
      final RegExpMatch? match = regex.firstMatch(frame);

      if (match != null) {
        final String path = match.group(1)!;
        final String caller = path.split('/').last;
        
        return caller;
      }
    }
    return 'Unknown';
  }
}