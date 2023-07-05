import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'model/entry_data.dart';
import 'model/entry_filter.dart';
import 'model/tag_data.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/pret_view.dart';
import 'widgets/sidebar.dart';

const uuID = Uuid();

final entryListProvider =
    StateNotifierProvider<PeregrineEntryList, Map<String, PeregrineEntry>>(
  (ref) => PeregrineEntryList(ref: ref),
);
final entryCount = Provider<int>((ref) => ref.watch(entryListProvider).length);
final tagsProvider = StateNotifierProvider<TagsList, Map<String, int>>(
  (_) => TagsList(),
);
final entryFilterProvider =
    StateNotifierProvider<PeregrineEntryFilter, EntryFilter>(
  (_) => PeregrineEntryFilter(),
);
final filteredListProvider = Provider((ref) {
  var entries = ref.watch(entryListProvider);
  final filter = ref.watch(entryFilterProvider);
  for (final item in filter.includes.keys) {
    var condition = filter.includes[item];
    switch (item) {
      case FilterType.search:
        if (condition != '') {
          entries = {
            for (final entryId in entries.keys)
              // if (entries[entryId]!.input.toLowerCase().contains(RegExp(
              //     r'/(^|\s|\@|\#)(' +
              //         condition!.toLowerCase() +
              //         r')(\Z|\s)')))
              if (entries[entryId]!
                  .input
                  .toLowerCase()
                  .contains(condition!.toLowerCase()))
                entryId: entries[entryId]!
          };
        }
        break;
      case FilterType.tag:
        entries = {
          for (final entryId in entries.keys)
            if (entries[entryId]!.tags.contains(condition))
              entryId: entries[entryId]!
        };
        break;
      case FilterType.contact:
        entries = {
          for (final entryId in entries.keys)
            if (entries[entryId]!.mentionedContacts.contains(condition))
              entryId: entries[entryId]!
        };
        break;
    }
  }
  return entries;
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(entryListProvider.notifier).readLog();
    ref.read(tagsProvider.notifier).readTags();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffb69d7c)),
        useMaterial3: true,
      ),
      home: const PeregrineHomeView(),
    );
  }
}

class PeregrineHomeView extends StatelessWidget {
  const PeregrineHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PretMainView(
        leftSidebar: Sidebar(),
        mainView: EntryListView(),
        barColor: Color(0xffb69d7c),
      ),
    );
  }
}
