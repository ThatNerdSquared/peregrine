import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../format_utils.dart';
import '../main.dart';
import 'json_backend.dart';

class PeregrineEntryList extends StateNotifier<Map<String, PeregrineEntry>> {
  final Ref ref;

  PeregrineEntryList({
    Map<String, PeregrineEntry>? initialEntries,
    required this.ref,
  }) : super(initialEntries ?? <String, PeregrineEntry>{}) {
    readLog();
  }

  void readLog() {
    state = JsonBackend().readEntriesFromJson();
  }

  void _writeLog() {
    JsonBackend().writeDataToJson(state, 'entries');
  }

  void addNewEntry(String input) {
    // NOTE: dedupe the findTags here and the findTags inside scanForTags
    ref.read(tagsProvider.notifier).scanForTags(input);
    final foundTags = findTags(input);
    final isAutoEncrypt =
        ref.read(tagsProvider.notifier).checkForAutoEncryptTag(foundTags);
    state = {
      ...state,
      uuID.v4(): PeregrineEntry(
        date: DateTime.now(),
        input: input,
        isEncrypted: isAutoEncrypt,
        tags: findTags(input),
        mentionedContacts: findContacts(input),
      ),
    };
    _writeLog();
  }
}

class PeregrineEntry extends PretDataclass {
  final DateTime date;
  final String input;
  final bool isEncrypted;
  final List<String> tags;
  final List<String> mentionedContacts;

  PeregrineEntry({
    required this.date,
    required this.input,
    required this.isEncrypted,
    required this.tags,
    required this.mentionedContacts,
  });

  @override
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
