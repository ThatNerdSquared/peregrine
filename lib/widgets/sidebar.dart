import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../context_menu_utils.dart';
import '../main.dart';
import 'entry_list_view.dart';

class Sidebar extends ConsumerWidget {
  final FocusNode entryBoxFocusNode;
  final FocusNode searchBoxFocusNode;

  const Sidebar({
    super.key,
    required this.entryBoxFocusNode,
    required this.searchBoxFocusNode,
  });

  void _onSidebarButtonPress({
    required ref,
    required context,
    tagName,
  }) {
    if (tagName == null) {
      ref.read(entryFilterProvider.notifier).setAllEntriesFilter();
    } else {
      ref.read(entryFilterProvider.notifier).setTagFilter(tagName);
    }
    if (Platform.isAndroid || Platform.isIOS) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: EntryListView(
              entryBoxFocusNode: entryBoxFocusNode,
              searchBoxFocusNode: searchBoxFocusNode,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider);
    final filter = ref.watch(entryFilterProvider);
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
            padding: const EdgeInsets.only(
                top: PretConfig.defaultElementSpacing,
                left: PretConfig.defaultElementSpacing,
                right: PretConfig.defaultElementSpacing),
            child: PretSidebarButton(
              color:
                  Color(filter.name == 'All Entries' ? 0xfff7f2f2 : 0xffdac6b0),
              onPressedCallback: () => _onSidebarButtonPress(
                ref: ref,
                context: context,
              ),
              buttonText: const Text('All Entries'),
              count: ref.read(entryCount),
              icon: Icons.all_inbox_rounded,
            )),
      ),
      SliverToBoxAdapter(
          child: SidebarToggleList(
        toggleTitle: 'Tags',
        items: tags.keys.map((tagName) {
          return Container(
              padding: const EdgeInsets.only(
                  left: PretConfig.defaultElementSpacing,
                  right: PretConfig.defaultElementSpacing),
              child: ContextMenuRegion(
                contextMenu: buildTagButtonContextMenu(
                  tagName,
                  tags[tagName]!,
                  (name) =>
                      ref.read(tagsProvider.notifier).toggleAutoEncrypt(name),
                  ref.watch(filteredListProvider).values.toList(),
                ),
                child: PretSidebarButton(
                  color:
                      Color(filter.name == tagName ? 0xfff7f2f2 : 0xffdac6b0),
                  onPressedCallback: () => _onSidebarButtonPress(
                    ref: ref,
                    context: context,
                    tagName: tagName,
                  ),
                  buttonText: tags[tagName]!.autoEncrypt && ref.watch(isLocked)
                      ? const Text.rich(TextSpan(text: '🔒', children: [
                          TextSpan(
                            text: 'Locked',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ]))
                      : Text(tagName),
                  count: tags[tagName]!.count,
                  icon: Icons.tag,
                ),
              ));
        }),
      )),
    ]);
  }
}

class SidebarToggleList extends StatelessWidget {
  final Iterable items;
  final String toggleTitle;

  const SidebarToggleList(
      {super.key, required this.items, required this.toggleTitle});

  @override
  Widget build(BuildContext context) {
    var customTileExpanded = true;
    return StatefulBuilder(builder: (context, setState) {
      return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            initiallyExpanded: true,
            leading: Icon(customTileExpanded
                ? Icons.arrow_drop_down_circle_rounded
                : Icons.arrow_drop_down_circle_outlined),
            title: Text(toggleTitle),
            onExpansionChanged: (expanded) => setState(() {
              customTileExpanded = expanded;
            }),
            children: [
              const Padding(
                  padding:
                      EdgeInsets.only(top: PretConfig.defaultElementSpacing)),
              ...items,
              const Padding(
                  padding:
                      EdgeInsets.only(top: PretConfig.defaultElementSpacing)),
            ],
          ));
    });
  }
}
