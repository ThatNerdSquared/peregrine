import 'dart:io';

import 'package:pret_a_porter/pret_a_porter.dart';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'entry_data.dart';
import 'tag_data.dart';

class JsonBackend extends PretJsonManager {
  @override
  final dataFile = File(Config.logFilePath);
  @override
  String schemaVersion = '2.2.0';
  @override
  Map<String, List<String>> dropFields = {};
  @override
  Map get freshJson => <String, dynamic>{
        'schema': schemaVersion,
        'hashedPwd': '',
        'tags': {},
        'entries': {},
      };

  Map<String, PeregrineEntry> readEntriesFromJson() {
    final contentsMap = pretLoadJson();
    if (contentsMap is List) {
      return _parseV1(contentsMap);
    }
    return switch (contentsMap['schema'] as String) {
      '2.0.0' => _parseV2_0(contentsMap),
      '2.1.0' => _parseV2_1(contentsMap),
      '2.2.0' => _parseV2_2(contentsMap),
      _ => throw UnimplementedError(
          "Schema version ${contentsMap['schema']} invalid!")
    };
  }

  // NOTE: write a version of this that doesn't break on v1 log format!
  Map<String, PeregrineTag> readTagsFromJson() {
    final contentsMap = pretLoadJson();
    final entries = readEntriesFromJson();
    var tags = <String, PeregrineTag>{};
    if (contentsMap is! List && contentsMap['tags'] != null) {
      tags = {
        for (final item in contentsMap['tags'].entries)
          item.key: PeregrineTag(
            autoEncrypt: item.value['autoEncrypt'],
            count: entries.values
                .where((entry) => entry.tags.contains(item.key))
                .length,
          )
      };
    }
    return sortTags(tags);
  }

  String readHashedPwd() {
    final contentsMap = pretLoadJson();
    return contentsMap['hashedPwd'];
  }

  Map<String, PeregrineEntry> _parseV1(contentsMap) {
    final data = Map<String, PeregrineEntry>.from({
      for (final value in contentsMap)
        uuID.v4(): PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['encrypted'] ?? false,
          entryType: EntryType.standard,
          tags: findTags(value['input']),
          mentionedContacts: findContacts(value['input']),
          ancestors: const [],
          descendants: const [],
        )
    });
    dangerousJsonReplace({
      'entries': data,
    });
    return data;
  }

  Map<String, PeregrineEntry> _parseV2_0(contentsMap) {
    final entriesMap = contentsMap['entries'];
    final data = Map<String, PeregrineEntry>.from(entriesMap.map(
      (key, value) => MapEntry(
        key,
        PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['isEncrypted'],
          entryType: EntryType.standard,
          tags: List<String>.from(value['tags']),
          mentionedContacts: List<String>.from(value['mentionedContacts']),
          ancestors: const [],
          descendants: const [],
        ),
      ),
    ));
    writeDataToJson(data, 'entries');
    return data;
  }

  Map<String, PeregrineEntry> _parseV2_1(contentsMap) {
    final entriesMap = contentsMap['entries'];
    return Map<String, PeregrineEntry>.from(entriesMap.map(
      (key, value) => MapEntry(
        key,
        PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['isEncrypted'],
          entryType: EntryType.standard,
          tags: List<String>.from(value['tags']),
          mentionedContacts: List<String>.from(value['mentionedContacts']),
          ancestors: List<String>.from(value['ancestors']),
          descendants: List<String>.from(value['descendants']),
        ),
      ),
    ));
  }

  Map<String, PeregrineEntry> _parseV2_2(contentsMap) {
    final entriesMap = contentsMap['entries'];
    return Map<String, PeregrineEntry>.from(entriesMap.map(
      (key, value) => MapEntry(
        key,
        PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['isEncrypted'],
          entryType: (value['entryType'] as String).toEntryType(),
          tags: List<String>.from(value['tags']),
          mentionedContacts: List<String>.from(value['mentionedContacts']),
          ancestors: List<String>.from(value['ancestors']),
          descendants: List<String>.from(value['descendants']),
        ),
      ),
    ));
  }
}
