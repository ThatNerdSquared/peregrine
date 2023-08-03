import 'dart:io';

import 'package:pret_a_porter/pret_a_porter.dart';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'entry_data.dart';

class JsonBackend extends PretJsonManager {
  @override
  final dataFile = File(Config().logFilePath);
  @override
  final freshJson = <String, dynamic>{
    'schema': Config.currentSchemaVersion,
    'tags': [],
    'entries': {},
  };

  void writeEntriesToJson(
    Map<String, PeregrineEntry> logToWrite,
  ) {
    jsonWriteWrapper((initialData) {
      final mappifiedLog = logToWrite.map((key, value) => MapEntry(
            key,
            value.toJson(),
          ));
      initialData['entries'] = mappifiedLog;
      return initialData;
    });
  }

  void writeTagsToJson(Map<String, int> tagsToWrite) {
    jsonWriteWrapper((initialData) {
      initialData['tags'] = tagsToWrite.keys.toList();
      return initialData;
    });
  }

  Map<String, PeregrineEntry> readEntriesFromJson() {
    final contentsMap = pretLoadJson();
    if (contentsMap is List) {
      return _parseV1(contentsMap);
    }
    return _parseV2(contentsMap);
  }

  Map<String, int> readTagsFromJson() {
    final contentsMap = pretLoadJson();
    var tags = <String, int>{};
    if (contentsMap is! List && contentsMap['tags'] != null) {
      tags = {for (final item in contentsMap['tags']) item: 0};
    }
    final items = readEntriesFromJson();
    for (final entryId in items.keys) {
      for (final tag in items[entryId]!.tags) {
        if (tags[tag] != null) {
          tags[tag] = tags[tag]! + 1;
        } else {
          tags[tag] = 1;
        }
      }
    }
    final sortedEntries = tags.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final entry in sortedEntries) entry.key: entry.value};
  }

  Map<String, PeregrineEntry> _parseV1(contentsMap) {
    final data = Map<String, PeregrineEntry>.from({
      for (final value in contentsMap)
        uuID.v4(): PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['encrypted'] ?? false,
          tags: findTags(value['input']),
          mentionedContacts: findContacts(value['input']),
        )
    });
    jsonWriteWrapper((initialData) {
      var item = freshJson;
      item['entries'] = data;
      return item;
    });
    return data;
  }

  Map<String, PeregrineEntry> _parseV2(contentsMap) {
    final entriesMap = contentsMap['entries'];
    return Map<String, PeregrineEntry>.from(entriesMap.map(
      (key, value) => MapEntry(
        key,
        PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['isEncrypted'],
          tags: List<String>.from(value['tags']),
          mentionedContacts: List<String>.from(value['mentionedContacts']),
        ),
      ),
    ));
  }
}
