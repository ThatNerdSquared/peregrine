import 'package:contextual_menu/contextual_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'export_utils.dart';
import 'model/entry_data.dart';

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
  List<PeregrineEntry> entries,
) =>
    Menu(
      items: [
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
