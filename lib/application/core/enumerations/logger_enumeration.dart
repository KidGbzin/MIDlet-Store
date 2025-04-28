import 'dart:developer' as dart;

import 'package:intl/intl.dart';

/// An enumeration to [log] colored logs on the console.
///
/// Instead of using a single [log] function, use [Logger] for better code analysis and readability.
enum Logger {

  /// An [error] log.
  ///
  /// Used to [log] unhandled [Exception]s that break the application.
  error("31", "⛔"),

  /// An [information] log.
  ///
  /// Used to [log] general information that doesn't affect application functionality.
  information("36", "📣"),

  /// A [success] log.
  ///
  /// Used to [log] successful requests.
  success("32", "✅"),

  /// A [warning] log.
  ///
  /// Used to [log] alerts that do not break the application, such as "not found" actions.
  warning("33", "📢");

  /// Creates a [Logger] with the given [code] and [emoji].
  const Logger(this.code, this.emoji);

  /// The color code, each code represents a different color.
  ///
  /// - Code 30: Black;
  /// - Code 31: Red;
  /// - Code 32: Green;
  /// - Code 33: Yellow;
  /// - Code 34: Blue;
  /// - Code 35: Purple;
  /// - Code 36: Cyan;
  /// - Code 37: White.
  ///
  /// Any other code value will not affect the console text color.
  final String code;

  /// The leading emoji displayed in the console.
  final String emoji;

  /// Prints a log message to the console with colored text.
  ///
  /// The log message is prefixed with an [emoji] and its color is based on the [Logger] enumeration value.
  void print({
    required String label,
    required String message,
    StackTrace? stackTrace,
  }) {
    dart.log(
      ": \x1b[${code}m$emoji $label | $message\x1B[0m",
      name: " ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())} ",
      stackTrace: stackTrace,
    );
  }

  /// Prints a log message to the console with colored text and optional caller information.
  ///
  /// The message is prefixed with an [emoji] representing the log level and colored according to the [Logger] configuration.
  /// The log name includes the current timestamp, and optionally the name of the file that triggered the log.
  void log(String message, {StackTrace? stackTrace}) {
    final String caller = _caller(StackTrace.current, false);

    dart.log(
      ": \x1b[${code}m$emoji $message\x1B[0m",
      name: " ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}$caller ",
      stackTrace: stackTrace,
    );
  }

  /// Extracts the file name of the caller from a [StackTrace].
  String _caller(StackTrace stackTrace, bool showCaller) {
    if (!showCaller) return "";

    final List<String> frames = stackTrace.toString().split('\n');
  
    if (frames.length > 1) {
      final String callerFrame = frames[1];

      final RegExp regex = RegExp(r'\((.+?):(\d+):(\d+)\)');
      final RegExpMatch? match = regex.firstMatch(callerFrame);

      if (match != null) {
        final String path = match.group(1)!;
        final String caller = path.split('/').last;

        return " | $caller";
      }
    }
  
    return 'Unknown';
  }
}