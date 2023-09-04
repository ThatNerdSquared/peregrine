import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

import 'model/entry_data.dart';
import 'model/entry_filter.dart';
import 'model/tag_data.dart';
import 'widgets/desktop_frame.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/sidebar.dart';

const uuID = Uuid();
String platformAppSupportDir = '';

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

FocusNode entryBoxFocusNode = FocusNode();
FocusNode searchBoxFocusNode = FocusNode();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  I'm aware that according to the `path_provider` docs, we
  // 'should not use this directory for user data files'.
  // HOWEVER: it is one of the few besides documents and temp
  // that are available on all platforms. Will consider
  // changing later.
  platformAppSupportDir = (await getApplicationSupportDirectory()).path;
  runApp(const ProviderScope(child: MyApp()));
  entryBoxFocusNode.requestFocus();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffb69d7c)),
        fontFamily: 'Krete',
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
    return Scaffold(
      body: DesktopFrame(
        entryBoxFocusNode: entryBoxFocusNode,
        searchBoxFocusNode: searchBoxFocusNode,
        child: PretMainView(
          leftSidebar: Sidebar(
            searchBoxFocusNode: searchBoxFocusNode,
            entryBoxFocusNode: entryBoxFocusNode,
          ),
          mainView: EntryListView(
            entryBoxFocusNode: entryBoxFocusNode,
            searchBoxFocusNode: searchBoxFocusNode,
          ),
          barColor: const Color(0xffb69d7c),
        ),
      ),
    );
  }
}
