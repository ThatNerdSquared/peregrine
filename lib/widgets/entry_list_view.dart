import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'peregrine_entry_box.dart';
import 'peregrine_entry_card.dart';

class EntryListView extends ConsumerWidget {
  const EntryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var entries = ref.watch(filteredListProvider).keys.toList();
    var filter = ref.watch(entryFilterProvider);
    return Column(children: [
      Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                  padding: const EdgeInsets.all(Config.preserveShadowSpacing),
                  sliver: SliverAppBar(
                    shape: const RoundedRectangleBorder(
                        borderRadius: Config.defaultBorderRadius),
                    pinned: true,
                    centerTitle: false,
                    backgroundColor: const Color(0xffb69d7c),
                    title: Padding(
                        padding:
                            const EdgeInsets.all(Config.defaultElementSpacing),
                        child: Row(children: [
                          Expanded(flex: 2, child: Text(filter)),
                          const Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(
                                        Config.defaultElementSpacing),
                                    border: OutlineInputBorder()),
                              )),
                        ])),
                  )),
              SliverList.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    var entryId = entries[index];
                    return PeregrineEntryCard(entryId: entryId);
                  })
            ],
          )),
      const Padding(
          padding: EdgeInsets.all(Config.defaultElementSpacing),
          child: PeregrineEntryBox())
      // )
    ]);
  }
}
