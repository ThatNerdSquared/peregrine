import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'peregrine_app_bar.dart';
import 'peregrine_entry_box.dart';
import 'peregrine_entry_card.dart';

class EntryListView extends ConsumerWidget {
  const EntryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var entries = ref.watch(filteredListProvider).keys.toList();
    return Scaffold(
      body: Stack(children: [
        Column(children: [
          Expanded(
            flex: 3,
            child: CustomScrollView(
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.all(Config.defaultElementSpacing * 5 / 2),
                ),
                SliverList.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      var entryId = entries[index];
                      return PeregrineEntryCard(entryId: entryId);
                    })
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(Config.defaultElementSpacing),
            child: PeregrineEntryBox(),
          ),
        ]),
        const PeregrineAppBar(),
      ]),
    );
  }
}
