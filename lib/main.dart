import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'model/entry_data.dart';
import 'model/tag_data.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/sidebar.dart';
import 'widgets/splitview.dart';

const uuID = Uuid();

final entryListProvider =
    StateNotifierProvider<PeregrineEntryList, Map<String, PeregrineEntry>>(
  (ref) => PeregrineEntryList(ref: ref),
);
final entryCount = Provider<int>((ref) => ref.watch(entryListProvider).length);
final tagsProvider = StateNotifierProvider<TagsList, Map<String, int>>(
  (_) => TagsList(),
);
final entryFilterProvider = StateProvider<String>((_) => 'All Entries');
final filteredListProvider = Provider((ref) {
  final entries = ref.watch(entryListProvider);
  final filter = ref.watch(entryFilterProvider);
  return switch (filter) {
    'All Entries' => entries,
    _ => {
        for (final entryId in entries.keys)
          if (entries[entryId]!.tags.contains(filter)) entryId: entries[entryId]
      }
  };
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
      body: SplitView(
        axis: Axis.horizontal,
        providedFirstFraction: 0.3,
        child1: Sidebar(),
        child2: EntryListView(),
      ),
    );
  }
}
