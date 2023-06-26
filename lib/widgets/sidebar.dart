import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'pret_tag_button.dart';

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
                      left: Config.defaultElementSpacing,
                      right: Config.defaultElementSpacing),
                  child: PretTagButton(
                    isSidebarButton: true,
                    color: Color(filter == null ? 0xfff7f2f2 : 0xffdac6b0),
                    onPressedCallback: () =>
                        ref.read(entryFilterProvider.notifier).state = null,
                    tagName: 'All Entries',
                    tagCount: ref.read(entryCount),
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
                            child: PretTagButton(
                              isSidebarButton: true,
                              color: Color(
                                  filter == tagName ? 0xfff7f2f2 : 0xffdac6b0),
                              onPressedCallback: () => ref
                                  .read(entryFilterProvider.notifier)
                                  .state = tagName,
                              tagName: tagName,
                              tagCount: tags[tagName],
                            ));
                      })
                    ],
                  )),
            )
          ]));
    });
  }
}
