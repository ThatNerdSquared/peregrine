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
                    centerTitle: false,
                    backgroundColor: const Color(0xffb69d7c),
                    leading: Icon(filter.icon),
                    pinned: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: Config.defaultBorderRadius),
                    titleSpacing: 0,
                    title: Row(children: [
                      Expanded(flex: 2, child: Text(filter.name)),
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    Config.defaultElementSpacing),
                                border: OutlineInputBorder(),
                                hintText: 'Search...'),
                            onChanged: (value) => ref
                                .read(entryFilterProvider.notifier)
                                .addSearch(value),
                          )),
                    ])),
              ),
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
