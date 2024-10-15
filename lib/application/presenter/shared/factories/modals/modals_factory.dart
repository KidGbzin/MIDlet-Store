import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/midlet_entity.dart';
import '../../../../core/enumerations/palette_enumeration.dart';
import '../../../../core/enumerations/tag_enumeration.dart';
import '../../../../core/enumerations/typographies_enumeration.dart';

import '../../widgets/section_widget.dart';

import '../buttons_factory.dart';

part '../modals/components/categories_filter_component.dart';
part '../modals/components/publishers_filter_component.dart';

part '../modals/objects/filter_modal.dart';
part '../modals/objects/midlets_modal.dart';

/// A factory for creating [Widget] modals.
class Modals extends StatelessWidget {

  const Modals._internal({
    required this.child,
    required this.onClose,
    this.onFinish,
    required this.title,
  });

  /// The content of a modal.
  final Widget child;

  /// The function for cancel the modal action.
  /// 
  /// This function is used when the "❌" button is tapped.
  final void Function() onClose;

  /// The function for finish the modal action.
  /// 
  /// This function is used when the "✅" button is tapped.
  final void Function()? onFinish;

  /// The modal's title.
  /// 
  /// This title is shown on the modal header.
  final String title;

  /// The filter modal.
  /// 
  /// Used on the [Search] view to filter the search query.
  factory Modals.filter({
    required ValueNotifier<String?> publisherState,
    required ValueNotifier<List<String>> tagsState,
    required void Function() applyFilters,
    required void Function() clearFilters,
  }) {
    return Modals._internal(
      onFinish: applyFilters,
      onClose: clearFilters,
      title: 'Filter Search',
      child: _Filter(
        publisherState: publisherState,
        tagsState: tagsState,
      ),
    );
  }

  /// The midlets modal.
  /// 
  /// Used on the [Details] view to show all the game midlets available.
  factory Modals.midlets({
    required void Function(MIDlet) installMIDlet,
    required List<MIDlet> midlets,
  }) {
    return Modals._internal(
      onClose: () {},
      title: 'Change Version',
      child: _MIDlets(
        installMIDlet: installMIDlet,
        midlets: midlets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return Column(
          children: <Widget> [
            Material(
              color: Palette.background.color,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(
                      title.toUpperCase(),
                      style: Typographies.headline(Palette.elements).style,
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: onFinish != null ? 7.5 : 0,
                      children: <Widget> [
                        Button(
                          icon: Icons.clear_rounded,
                          onTap: () {
                            onClose();
                            context.pop();
                          },
                        ),
                        Visibility(
                          visible: onFinish != null,
                          child: Button(
                            icon: Icons.check_rounded,
                            onTap: () {
                              if (onFinish != null) onFinish!();
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Palette.divider.color,
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: child,
            ),
          ],
        );
      },
      clipBehavior: Clip.hardEdge,
      enableDrag: false,
      onClosing: () {},
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      showDragHandle: false,
    );
  }
}