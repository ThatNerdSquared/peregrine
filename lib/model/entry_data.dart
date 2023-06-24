import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format_utils.dart';
import '../main.dart';
import 'json_backend.dart';

class PeregrineEntryList extends StateNotifier<Map<String, PeregrineEntry>> {
  final Ref ref;

  PeregrineEntryList({
    Map<String, PeregrineEntry>? initialEntries,
    required this.ref,
  }) : super(initialEntries ?? <String, PeregrineEntry>{});

  void readLog() async {
    state = await JsonBackend().readEntriesFromJson();
  }

  void _writeLog() {
    var mappifiedLog = state.map((key, value) => MapEntry(key, value.toJson()));
    JsonBackend().writeEntriesToJson(mappifiedLog);
  }

  void addNewEntry(String input) {
    state = {
      ...state,
      uuID.v4(): PeregrineEntry(
        date: DateTime.now(),
        input: input,
        isEncrypted: false,
        tags: findTags(input),
        mentionedContacts: findContacts(input),
      ),
    };
    ref.read(tagsProvider.notifier).scanForTags(input);
    _writeLog();
  }
}

@immutable
class PeregrineEntry {
  final DateTime date;
  final String input;
  final bool isEncrypted;
  final List<String> tags;
  final List<String> mentionedContacts;

  const PeregrineEntry({
    required this.date,
    required this.input,
    required this.isEncrypted,
    required this.tags,
    required this.mentionedContacts,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'input': input,
      'isEncrypted': isEncrypted,
      'tags': tags,
      'mentionedContacts': mentionedContacts,
    };
  }
}
