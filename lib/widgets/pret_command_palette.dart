import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

class PretCmdPaletteScope extends ConsumerStatefulWidget {
  final Widget child;
  final List<String> searchItems;

  const PretCmdPaletteScope({
    super.key,
    required this.child,
    required this.searchItems,
  });

  @override
  PretCmdPaletteScopeState createState() => PretCmdPaletteScopeState();
}

class PretCmdPaletteScopeState extends ConsumerState<PretCmdPaletteScope> {
  bool _isPaletteShown = false;

  void togglePalette() => setState(() {
        _isPaletteShown = !_isPaletteShown;
      });

  @override
  Widget build(BuildContext context) => PretPaletteToggle(
        isPaletteShown: _isPaletteShown,
        togglePalette: togglePalette,
        child: !_isPaletteShown
            ? widget.child
            : LayoutBuilder(
                builder: (context, constraints) => Container(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      widget.child,
                      CallbackShortcuts(
                        bindings: <ShortcutActivator, VoidCallback>{
                          const SingleActivator(
                            LogicalKeyboardKey.escape,
                          ): togglePalette
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: min(0.8 * constraints.maxHeight, 600),
                            maxWidth: min(0.8 * constraints.maxWidth, 900),
                          ),
                          child: PretCard(
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: true,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: widget.searchItems.length,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(widget.searchItems[index]),
                                      onTap: () {
                                        togglePalette();
                                        ref
                                            .read(entryFilterProvider.notifier)
                                            .setTagFilter(
                                              widget.searchItems[index],
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      );
}

class PretPaletteToggle extends InheritedWidget {
  final bool isPaletteShown;
  final VoidCallback togglePalette;

  const PretPaletteToggle({
    super.key,
    required this.isPaletteShown,
    required this.togglePalette,
    required Widget child,
  }) : super(child: child);

  static PretPaletteToggle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PretPaletteToggle>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
    // TODO: implement updateShouldNotify
    // throw UnimplementedError();
  }
}
