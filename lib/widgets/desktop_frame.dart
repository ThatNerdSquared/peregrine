import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';
import '../model/tag_data.dart';
import 'pret_command_palette.dart';

class DesktopFrame extends ConsumerWidget {
  final Widget child;
  final FocusNode entryBoxFocusNode;
  final FocusNode searchBoxFocusNode;

  const DesktopFrame({
    super.key,
    required this.child,
    required this.entryBoxFocusNode,
    required this.searchBoxFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider);
    return PlatformMenuBar(
      menus: [
        pretAppNameMenu(appName: 'Peregrine'),
        PlatformMenu(
          label: 'File',
          menus: [
            PlatformMenuItemGroup(
              members: [
                PlatformMenuItem(
                  label: 'New Entry',
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyN,
                    meta: true,
                  ),
                  onSelected: entryBoxFocusNode.requestFocus,
                ),
                PlatformMenuItem(
                  label: 'Quick Open Tag',
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyP,
                    meta: true,
                  ),
                  onSelected: () =>
                      PretPaletteToggle.of(context).togglePalette(),
                ),
              ],
            ),
          ],
        ),
        addItemToPlatformMenu(menu: pretDefaultEditMenu, itemsToAdd: [
          PlatformMenuItemGroup(members: [
            PlatformMenuItem(
              label: 'Find',
              shortcut:
                  const SingleActivator(LogicalKeyboardKey.keyF, meta: true),
              onSelected: searchBoxFocusNode.requestFocus,
            ),
          ]),
        ]),
        PlatformMenu(label: 'View', menus: [
          const PlatformMenuItemGroup(members: [
            PlatformProvidedMenuItem(
                type: PlatformProvidedMenuItemType.toggleFullScreen)
          ]),
          PlatformMenu(label: 'Go To Tag', menus: [
            PlatformMenuItem(
                label: 'All Entries',
                shortcut: const SingleActivator(LogicalKeyboardKey.digit0,
                    meta: true),
                onSelected:
                    ref.read(entryFilterProvider.notifier).setAllEntriesFilter),
            ..._buildTagMenuItems(ref, tags),
          ]),
        ]),
        pretDefaultWindowMenu,
      ],
      child: child,
    );
  }
}

List _buildTagMenuItems(WidgetRef ref, Map<String, PeregrineTag> tags) {
  final tagIndexKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];
  final items = [];
  var idx = 0;
  for (final tag in tags.keys) {
    items.add(PlatformMenuItem(
        label: tag,
        shortcut:
            idx < 9 ? SingleActivator(tagIndexKeys[idx], meta: true) : null,
        onSelected: () =>
            ref.read(entryFilterProvider.notifier).setTagFilter(tag)));
    idx++;
  }
  return items;
}
