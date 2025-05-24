part of '../midlets_handler.dart';

class _MIDletsCounter extends StatelessWidget {

  /// Controls the handler’s state and behavior logic.
  final _Controller controller;

  const _MIDletsCounter(this.controller);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.nMIDletsLength,
      builder: (BuildContext context, int length, Widget? _) {
        return SizedBox.square(
          dimension: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$length",
              textAlign: TextAlign.center,
              style: TypographyEnumeration.body(ColorEnumeration.elements).style,
            ),
          ),
        );
      }
    );
  }
}