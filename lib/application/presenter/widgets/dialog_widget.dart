import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:midlet_store/globals.dart';

import '../../core/enumerations/palette_enumeration.dart';

// DIALOG WIDGET 🧩: ============================================================================================================================================================ //

/// The father of all application dialogs.
/// 
/// The [DialogWidget] is a reusable widget that can be used to create custom dialogs with a consistent design.
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
  /// Adjust the dialog's width only when the dialog body contains views such as [ListView], [PageView], etc.
  /// 
  /// To calculate the default width, the widget subtracts 90 from the [MediaQuery]'s width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 7.5,
        sigmaY: 7.5,
      ),
      child: Dialog(
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
      ),
    );
  }
}
