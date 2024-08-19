import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';
import 'model/current_ancestors.dart';
import 'model/entry_data.dart';
import 'model/entry_filter.dart';
import 'model/json_backend.dart';
import 'model/tag_data.dart';
import 'widgets/desktop_frame.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/pret_command_palette.dart';
import 'widgets/sidebar.dart';

const uuID = Uuid();
String platformAppSupportDir = '';
final String hashedPwd = JsonBackend().readHashedPwd();

final entryListProvider =
    StateNotifierProvider<PeregrineEntryList, Map<String, PeregrineEntry>>(
  (ref) => PeregrineEntryList(ref: ref),
);
final entryCount = Provider<int>((ref) => ref.watch(entryListProvider).length);
final isLocked = StateProvider<bool>((ref) => true);
final tagsProvider = StateNotifierProvider<TagsList, Map<String, PeregrineTag>>(
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
final currentAncestorsProvider =
    StateNotifierProvider<CurrentAncestors, List<String>>(
  (_) => CurrentAncestors(),
);

FocusNode entryBoxFocusNode = FocusNode();
FocusNode searchBoxFocusNode = FocusNode();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformAppSupportDir = (await getApplicationDocumentsDirectory()).path;
  runApp(const ProviderScope(child: MyApp()));
  entryBoxFocusNode.requestFocus();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: uuID.v4(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffb69d7c)),
        fontFamily: 'Krete',
        useMaterial3: true,
      ),
      home: const PeregrineHomeView(),
    );
  }
}

class PeregrineHomeView extends ConsumerWidget {
  const PeregrineHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = PretMainView(
      leftSidebar: Sidebar(
        searchBoxFocusNode: searchBoxFocusNode,
        entryBoxFocusNode: entryBoxFocusNode,
      ),
      mainView: EntryListView(
        entryBoxFocusNode: entryBoxFocusNode,
        searchBoxFocusNode: searchBoxFocusNode,
      ),
      barColor: const Color(0xffb69d7c),
      dividerColor: Theme.of(context).scaffoldBackgroundColor,
    );
    if (Config.isMobile) {
      return view;
    }
    return Scaffold(
      backgroundColor: const Color(0xffb69d7c),
      body: PretCmdPaletteScope(
        searchItems: ref.read(tagsProvider).keys.toList(),
        child: DesktopFrame(
          entryBoxFocusNode: entryBoxFocusNode,
          searchBoxFocusNode: searchBoxFocusNode,
          child: view,
        ),
      ),
    );
  }
}
