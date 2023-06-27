import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'pret_sidebar_button.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider);
    final filter = ref.watch(entryFilterProvider);
    var customTileExpanded = true;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          decoration: const BoxDecoration(
            color: Color(0xffb69d7c),
            borderRadius: BorderRadius.only(
              topRight: Config.defaultBorderRounding,
              bottomRight: Config.defaultBorderRounding,
            ),
            boxShadow: [Config.defaultShadow],
          ),
          padding: const EdgeInsets.only(
            top: Config.titleBarSafeArea,
          ),
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.only(
                      top: Config.defaultElementSpacing,
                      left: Config.defaultElementSpacing,
                      right: Config.defaultElementSpacing),
                  child: PretSidebarButton(
                    color: Color(
                        filter.name == 'All Entries' ? 0xfff7f2f2 : 0xffdac6b0),
                    onPressedCallback: () => ref
                        .read(entryFilterProvider.notifier)
                        .setAllEntriesFilter(),
                    buttonText: 'All Entries',
                    count: ref.read(entryCount),
                    icon: Icons.all_inbox_rounded,
                  )),
            ),
            SliverToBoxAdapter(
              child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    initiallyExpanded: true,
                    leading: Icon(customTileExpanded
                        ? Icons.arrow_drop_down_circle_rounded
                        : Icons.arrow_drop_down_circle_outlined),
                    title: const Text('Tags'),
                    onExpansionChanged: (expanded) => setState(() {
                      customTileExpanded = expanded;
                    }),
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(
                              top: Config.defaultElementSpacing)),
                      ...tags.keys.map((tagName) {
                        return Container(
                            padding: const EdgeInsets.only(
                                left: Config.defaultElementSpacing,
                                right: Config.defaultElementSpacing),
                            child: PretSidebarButton(
                              color: Color(
                                  filter.name == tagName.replaceAll('#', '')
                                      ? 0xfff7f2f2
                                      : 0xffdac6b0),
                              onPressedCallback: () => ref
                                  .read(entryFilterProvider.notifier)
                                  .setTagFilter(tagName),
                              buttonText: tagName.replaceAll('#', ''),
                              count: tags[tagName],
                              icon: Icons.tag,
                            ));
                      }),
                      const Padding(
                          padding: EdgeInsets.only(
                              top: Config.defaultElementSpacing)),
                    ],
                  )),
            )
          ]));
    });
  }
}
