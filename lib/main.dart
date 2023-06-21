import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'model/entry_data.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/sidebar.dart';
import 'widgets/splitview.dart';

const uuID = Uuid();

final mockIds = [uuID.v4(), uuID.v4(), uuID.v4()];

final entryListProvider =
    StateNotifierProvider<PeregrineEntryList, Map<String, PeregrineEntry>>(
  (ref) => PeregrineEntryList(initialEntries: {
    mockIds[0]: PeregrineEntry(
      date: DateTime.now(),
      input: 'whee',
      encrypted: false,
      tags: const [],
      mentionedContacts: const [],
    ),
    mockIds[1]: PeregrineEntry(
      date: DateTime.now(),
      input: 'whee2',
      encrypted: false,
      tags: const [],
      mentionedContacts: const [],
    ),
    mockIds[2]: PeregrineEntry(
      date: DateTime.now(),
      input: 'whee3',
      encrypted: false,
      tags: const [],
      mentionedContacts: const [],
    ),
  }),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
