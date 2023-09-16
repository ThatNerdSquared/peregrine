import 'package:contextual_menu/contextual_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'export_utils.dart';
import 'model/entry_data.dart';
import 'model/tag_data.dart';

class ContextMenuRegion extends StatefulWidget {
  final Widget child;
  final Menu contextMenu;
  const ContextMenuRegion({
    super.key,
    required this.contextMenu,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => ContextMenuRegionState();
}

class ContextMenuRegionState extends State<ContextMenuRegion> {
  bool _shouldReact = false;

  void _showContextMenu() {
    popUpContextualMenu(widget.contextMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _shouldReact = event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton;
      },
      onPointerUp: (event) {
        if (!_shouldReact) return;

        // _position = Offset(
        //   event.position.dx,
        //   event.position.dy,
        // );

        _showContextMenu();
      },
      child: widget.child,
    );
  }
}

Menu buildTagButtonContextMenu(
  String tagName,
  PeregrineTag tagInfo,
  Function(String) autoEncryptToggleCallback,
  List<PeregrineEntry> entries,
) =>
    Menu(
      items: [
        MenuItem.checkbox(
          label: 'Auto Encrypt',
          checked: tagInfo.autoEncrypt,
          onClick: (_) => autoEncryptToggleCallback(tagName),
        ),
        MenuItem.submenu(
          label: 'Export as...',
          submenu: Menu(
            items: [
              MenuItem(
                label: 'Markdown',
                onClick: (_) => exportMarkdown(
                  entries: entries,
                  logName: tagName,
                ),
              ),
            ],
          ),
        )
      ],
    );
