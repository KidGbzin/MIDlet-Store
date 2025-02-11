import 'package:flutter/material.dart';
import 'package:midlet_store/globals.dart';

import '../../core/enumerations/palette_enumeration.dart';

/// A factory for creating [Widget] dialogs.
class DialogWidget extends StatelessWidget {

  const DialogWidget({
    this.color,
    required this.child,
    this.width,
    super.key,
  });

  /// The background color of the dialog.
  ///
  /// If not specified, the dialog will use [ColorEnumeration.background] as the default color.
  final Color? color;

  /// The content of the dialog.
  final Widget child;

  /// The width of the dialog.
  ///
  /// If not specified, a default width is used.
  /// Change the dialog's width only when the dialog body contains views such as [ListView], [PageView], etc.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: color ?? ColorEnumeration.background.value,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius,
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