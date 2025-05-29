part of '../search_handler.dart';

// FILTER BUTTON 🧩: ============================================================================================================================================================ //

/// A button widget that displays a filter button.
///
/// This widget displays a button with a [title], [icon], and [color].
/// When tapped, the [onTap] callback is called.
///
/// The button is designed to be used in the [Search] view, where the filter button is displayed in the search bar.
class _FilterButton extends StatelessWidget {

  const _FilterButton({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.title,
  });

  /// The color of the button.
  ///
  /// This is the background color of the button.
  final Color color;

  /// The icon of the button.
  ///
  /// This is the icon that is displayed in the button.
  final IconData icon;

  /// The callback function that is called when the button is tapped.
  ///
  /// This callback is called when the button is tapped.
  final void Function() onTap;

  /// The title of the button.
  ///
  /// This is the text that is displayed in the button.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palettes.transparent.value,
      child: InkWell(
        borderRadius: gBorderRadius,
        onTap: onTap,
        child: FittedBox(
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: gBorderRadius,
              color: color,
            ),
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              spacing: 7.5,
              children: <Widget> [
                Text(
                  title,
                  style: TypographyEnumeration.body(Palettes.elements).style,
                ),
                HugeIcon(
                  icon: icon,
                  color: Palettes.elements.value,
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