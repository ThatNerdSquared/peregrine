import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

/// this only works above a PlatformMenuBar widget if
/// you comment out the `return false` in
/// [DefaultPlatformMenuDelegate.debugLockDelegate]. No idea why.
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
  int selectedIndex = 0;
  final TextEditingController _controller = TextEditingController();
  late List<String> filteredItems = widget.searchItems;
  final FocusNode paletteFocusNode = FocusNode();

  void togglePalette() => setState(() {
        _isPaletteShown = !_isPaletteShown;
        _controller.clear();
        filteredItems = widget.searchItems;
        selectedIndex = 0;
        _isPaletteShown ? paletteFocusNode.requestFocus() : null;
      });

  void handleSelect() {
    ref
        .read(entryFilterProvider.notifier)
        .setTagFilter(filteredItems[selectedIndex]);
    _controller.clear();
    updateFilteredItems(null);
    togglePalette();
  }

  void updateFilteredItems(_) => setState(() {
        filteredItems = widget.searchItems
            .where(
              (x) => x.contains(_controller.text.trim()),
            )
            .toList();
      });

  @override
  Widget build(BuildContext context) {
    return PretPaletteToggle(
      isPaletteShown: _isPaletteShown,
      togglePalette: togglePalette,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              widget.child,
              _isPaletteShown
                  ? CallbackShortcuts(
                      bindings: <ShortcutActivator, VoidCallback>{
                        const SingleActivator(
                          LogicalKeyboardKey.escape,
                        ): togglePalette,
                        const SingleActivator(
                          LogicalKeyboardKey.enter,
                        ): handleSelect,
                        const SingleActivator(
                          LogicalKeyboardKey.arrowDown,
                        ): () => setState(() {
                              selectedIndex = min(
                                widget.searchItems.length,
                                selectedIndex + 1,
                              );
                            }),
                        const SingleActivator(
                          LogicalKeyboardKey.arrowUp,
                        ): () => setState(() {
                              selectedIndex = max(selectedIndex - 1, 0);
                            }),
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: max(
                            0.2 * constraints.maxHeight,
                            (constraints.maxHeight - 600),
                          ),
                          left: max(
                            0.1 * constraints.maxWidth,
                            (constraints.maxWidth - 900) / 2,
                          ),
                          right: max(
                            0.1 * constraints.maxWidth,
                            (constraints.maxWidth - 900) / 2,
                          ),
                        ),
                        child: PretCard(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _controller,
                                autofocus: true,
                                onChanged: updateFilteredItems,
                                focusNode: paletteFocusNode,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) => ListTile(
                                    dense: true,
                                    title: Text('#${filteredItems[index]}'),
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        handleSelect();
                                      });
                                    },
                                    tileColor: Color(
                                      selectedIndex == index
                                          ? 0xffdac6b0
                                          : 0xfff7f2f2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class PretPaletteToggle extends InheritedWidget {
  final bool isPaletteShown;
  final VoidCallback togglePalette;

  const PretPaletteToggle({
    super.key,
    required super.child,
    required this.isPaletteShown,
    required this.togglePalette,
  });

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
