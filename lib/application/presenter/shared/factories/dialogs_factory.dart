import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enumerations/logger_enumeration.dart';
import '../../../core/enumerations/palette_enumeration.dart';
import '../../../core/enumerations/typographies_enumeration.dart';

import '../../../external/services/activity_service.dart';

import '../widgets/section_widget.dart';
import '../widgets/thumbnail_widget.dart';

part '../factories/dialogs/emulator_error_dialog.dart';
part '../factories/dialogs/error_dialog.dart';
part '../factories/dialogs/loader_dialog.dart';
part '../factories/dialogs/midlet_installer_dialog.dart';
part '../factories/dialogs/placeholder_dialog.dart';
part '../factories/dialogs/previews_dialog.dart';

/// A factory for creating [Widget] dialogs.
class Dialogs extends StatelessWidget {

  const Dialogs._({
    this.backgroundColor,
    required this.child,
    this.width,
  });

  /// The background color of the dialog.
  ///
  /// If not specified, the dialog will use [Palette.background] as the default color.
  final Color? backgroundColor;

   /// The content of the dialog.
  final Widget child;

  /// The width of the dialog.
  ///
  /// If not specified, a default width is used.
  /// Change the dialog's width only when the dialog body contains views such as [ListView], [PageView], etc.
  final double? width;

  /// A [Dialog] placeholder.
  ///
  /// This dialog shows a "Comming Soon" message to the user.
  factory Dialogs.placeholder() {
    return const Dialogs._(
      child: _Placeholder(),
    );
  }

  /// A [Dialog] that handles the installation of a MIDlet.
  factory Dialogs.installMIDlet({
    required Future<void> installMIDlet,
  }) {
    return Dialogs._(
      child: _MIDletInstaller(
        installMIDlet: installMIDlet,
      ),
    );
  }

  /// A [Dialog] that shows a scrollable list of previews.
  factory Dialogs.previews({
    required double aspectRatio,
    required int initialPage,
    required List<Uint8List> previews,
  }) {
    return Dialogs._(
      backgroundColor: Palette.transparent.color,
      width: double.infinity,
      child: _Previews(
        aspectRatio: aspectRatio,
        initialPage: initialPage,
        previews: previews,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: backgroundColor ?? Palette.background.color,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).width - 90,
        ),
        width: width ?? MediaQuery.sizeOf(context).width - 90,
        child: child,
      ),
    );
  }
}