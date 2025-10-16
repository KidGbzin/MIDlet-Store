part of '../search_handler.dart';

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
      color: Palettes.transparent.value,
      child: InkWell(
        borderRadius: gBorderRadius,
        onTap: onTap,
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
              Expanded(
                child: Text(
                  title,
                  style: TypographyEnumeration.body(Palettes.elements).style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
    );
  }
}