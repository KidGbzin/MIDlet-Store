import 'package:flutter/material.dart';

import '../../core/enumerations/palette_enumeration.dart';

/// A reusable factory widget for creating modal dialogs with a consistent design.
///
/// This widget is used to display a bottom sheet modal with a header containing customizable actions, a title, and a content area.
/// The modal supports a scrollable content area and adheres to the application's theme and design system.
class ModalWidget extends StatelessWidget {

  const ModalWidget({
    required this.actions,
    required this.child,
    super.key,
  });

  /// A list of action widgets displayed in the modal's header.
  ///
  /// These actions are typically buttons, icons, or other interactive widgets placed on the right side of the modal header.
  final List<Widget> actions;

  /// The main content of the modal.
  ///
  /// This widget is displayed in the expanded area of the modal, allowing for flexible layouts such as forms, lists, or other scrollable content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      clipBehavior: Clip.hardEdge,
      enableDrag: false,
      onClosing: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      showDragHandle: false,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [

            // The Material widget is used here to prevent splash effects from overflowing onto other children of the Column.
            Material(
              color: ColorEnumeration.background.value,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  spacing: 7.5,
                  children: actions,
                ),
              ),
            ),
            Divider(
              color: ColorEnumeration.divider.value,
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: child,
            ),
          ],
        );
      },
    );
  }
}