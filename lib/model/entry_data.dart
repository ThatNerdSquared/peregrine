import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../format_utils.dart';
import '../main.dart';
import 'json_backend.dart';

enum EntryType { standard, deprecated, archived }

extension ToEntryType on String {
  EntryType toEntryType() {
    return switch (this) {
      'EntryType.standard' => EntryType.standard,
      'EntryType.deprecated' => EntryType.deprecated,
      'EntryType.archived' => EntryType.archived,
      _ => throw ArgumentError(
          'String $this could not be converted to EntryType!',
        )
    };
  }
}

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

  void addNewEntry({required String input, required List<String> ancestors}) {
    // NOTE: dedupe the findTags here and the findTags inside scanForTags
    ref.read(tagsProvider.notifier).scanForTags(input);
    final foundTags = findTags(input);
    final isAutoEncrypt =
        ref.read(tagsProvider.notifier).checkForAutoEncryptTag(foundTags);
    final newEntryId = uuID.v4();
    state = state.map((key, value) {
      if (ancestors.contains(key)) {
        return MapEntry(
            key,
            PeregrineEntry(
              date: value.date,
              input: value.input,
              isEncrypted: value.isEncrypted,
              entryType: value.entryType,
              tags: value.tags,
              mentionedContacts: value.mentionedContacts,
              ancestors: value.ancestors,
              descendants: [...value.descendants, newEntryId],
            ));
      } else {
        return MapEntry(key, value);
      }
    });
    state = {
      ...state,
      newEntryId: PeregrineEntry(
        date: DateTime.now(),
        input: input,
        isEncrypted: isAutoEncrypt,
        entryType: EntryType.standard,
        tags: findTags(input),
        mentionedContacts: findContacts(input),
        ancestors: ancestors,
        descendants: const [],
      ),
    };
    _writeLog();
  }

  void stripTagFromEntries(String tag) {
    state = state.map((key, value) {
      if (value.tags.contains(tag)) {
        return MapEntry(
            key,
            PeregrineEntry(
              date: value.date,
              input: value.input,
              isEncrypted: value.isEncrypted,
              entryType: value.entryType,
              tags: value.tags.where((x) => x != tag).toList(),
              mentionedContacts: value.mentionedContacts,
              ancestors: value.ancestors,
              descendants: value.descendants,
            ));
      } else {
        return MapEntry(key, value);
      }
    });
    _writeLog();
  }

  void toggleEncrypt(String entryID) {
    state = state.map((key, value) {
      if (key == entryID) {
        return MapEntry(
            key,
            PeregrineEntry(
              date: value.date,
              input: value.input,
              isEncrypted: !value.isEncrypted,
              entryType: value.entryType,
              tags: value.tags,
              mentionedContacts: value.mentionedContacts,
              ancestors: value.ancestors,
              descendants: value.descendants,
            ));
      } else {
        return MapEntry(key, value);
      }
    });
    _writeLog();
  }
}

class PeregrineEntry extends PretDataclass {
  final DateTime date;
  final String input;
  final bool isEncrypted;
  final EntryType entryType;
  final List<String> tags;
  final List<String> mentionedContacts;
  final List<String> ancestors;
  final List<String> descendants;

  PeregrineEntry({
    required this.date,
    required this.input,
    required this.isEncrypted,
    required this.entryType,
    required this.tags,
    required this.mentionedContacts,
    required this.ancestors,
    required this.descendants,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'input': input,
      'isEncrypted': isEncrypted,
      'entryType': entryType.toString(),
      'tags': tags,
      'mentionedContacts': mentionedContacts,
      'ancestors': ancestors,
      'descendants': descendants,
    };
  }
}
