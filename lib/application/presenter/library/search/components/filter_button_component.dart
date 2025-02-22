part of '../search_handler.dart';

/// A button widget that displays a filter button.
///
/// This widget displays a button with a [title], [icon], and [color].
/// When tapped, the [onTap] callback is called.
class _FilterButton extends StatelessWidget {

  const _FilterButton({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.title,
  });

  final Color color;
  final IconData icon;
  final void Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorEnumeration.transparent.value,
      child: InkWell(
        borderRadius: kBorderRadius,
        onTap: onTap,
        child: FittedBox(
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              color: color,
            ),
            height: 35,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              spacing: 7.5,
              children: <Widget> [
                Text(
                  title,
                  style: TypographyEnumeration.body(ColorEnumeration.elements).style,
                ),
                HugeIcon(
                  icon: icon,
                  color: ColorEnumeration.elements.value,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}