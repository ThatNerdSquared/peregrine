import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

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

  PlatformMenu _appNameMenu() => PlatformMenu(
        label: 'Peregrine',
        menus: [
          PlatformMenuItemGroup(
            members: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.about))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.about),
            ],
          ),
          PlatformMenuItemGroup(
            members: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.servicesSubmenu))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.servicesSubmenu),
            ],
          ),
          PlatformMenuItemGroup(
            members: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.hide))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.hide),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.hideOtherApplications))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.hideOtherApplications),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.showAllApplications))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.showAllApplications),
            ],
          ),
          PlatformMenuItemGroup(members: [
            if (PlatformProvidedMenuItem.hasMenu(
                PlatformProvidedMenuItemType.quit))
              const PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit),
          ]),
        ],
      );

  PlatformMenu _defaultWindowMenu() => PlatformMenu(
        label: 'Window',
        menus: [
          PlatformMenuItemGroup(
            members: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.minimizeWindow))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.minimizeWindow),
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.zoomWindow))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.zoomWindow),
            ],
          ),
          PlatformMenuItemGroup(
            members: [
              if (PlatformProvidedMenuItem.hasMenu(
                  PlatformProvidedMenuItemType.arrangeWindowsInFront))
                const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.arrangeWindowsInFront),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tags = ref.watch(tagsProvider);
    return PlatformMenuBar(
      menus: [
        _appNameMenu(),
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
              ],
            ),
          ],
        ),
        PlatformMenu(label: 'Edit', menus: [
          const PlatformMenuItemGroup(
            members: [
              PlatformMenuItem(
                label: 'Undo',
                shortcut: SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
              ),
              PlatformMenuItem(
                label: 'Redo',
                shortcut: SingleActivator(LogicalKeyboardKey.keyZ,
                    meta: true, shift: true),
              ),
            ],
          ),
          const PlatformMenuItemGroup(
            members: [
              PlatformMenuItem(
                label: 'Cut',
                shortcut: SingleActivator(LogicalKeyboardKey.keyX, meta: true),
              ),
              PlatformMenuItem(
                label: 'Copy',
                shortcut: SingleActivator(LogicalKeyboardKey.keyC, meta: true),
              ),
              PlatformMenuItem(
                label: 'Paste',
                shortcut: SingleActivator(LogicalKeyboardKey.keyV, meta: true),
              ),
            ],
          ),
          PlatformMenuItemGroup(members: [
            PlatformMenuItem(
              label: 'Find',
              shortcut:
                  const SingleActivator(LogicalKeyboardKey.keyF, meta: true),
              onSelected: searchBoxFocusNode.requestFocus,
            ),
          ])
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
        _defaultWindowMenu()
      ],
      child: child,
    );
  }
}

List _buildTagMenuItems(WidgetRef ref, Map<String, int> tags) {
  var tagIndexKeys = [
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
  var items = [];
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
