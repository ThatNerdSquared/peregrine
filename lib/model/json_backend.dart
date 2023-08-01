import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'entry_data.dart';

class JsonBackend {
  static const JsonEncoder encoder = JsonEncoder.withIndent('    ');

  void _checkForLogFile() {
    final logFile = File(Config().logFilePath);
    final doesFileExist = logFile.existsSync();
    if (!doesFileExist) {
      logFile.create();
      _putJson(assembleFreshJson(entries: {}));
    }
  }

  dynamic _loadJson() {
    _checkForLogFile();
    final logFile = File(Config().logFilePath);
    final contents = logFile.readAsStringSync();
    return jsonDecode(contents);
  }

  void _putJson(String stringifiedLog) {
    _checkForLogFile();
    final logFile = File(Config().logFilePath);
    logFile.writeAsString(stringifiedLog);
  }

  String assembleFreshJson({
    required Map<String, PeregrineEntry> entries,
    List<String>? tags,
  }) {
    return encoder.convert(<String, dynamic>{
      'schema': Config.currentSchemaVersion,
      'tags': tags ?? [],
      'entries': entries,
    });
  }

  void writeEntriesToJson(
    Map<String, PeregrineEntry> logToWrite,
  ) {
    var rawLog = _loadJson();
    final mappifiedLog =
        logToWrite.map((key, value) => MapEntry(key, value.toJson()));
    rawLog['entries'] = mappifiedLog;
    final stringifiedLog = encoder.convert(rawLog);
    _putJson(stringifiedLog);
  }

  void writeTagsToJson(Map<String, int> tagsToWrite) {
    var rawLog = _loadJson();
    rawLog['tags'] = tagsToWrite.keys.toList();
    final stringifiedLog = encoder.convert(rawLog);
    _putJson(stringifiedLog);
  }

  Map<String, PeregrineEntry> readEntriesFromJson() {
    final contentsMap = _loadJson();
    if (contentsMap is List) {
      return _parseV1(contentsMap);
    }
    return _parseV2(contentsMap);
  }

  Map<String, int> readTagsFromJson() {
    final contentsMap = _loadJson();
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
    _putJson(assembleFreshJson(entries: data));
    return data;
  }

  Map<String, PeregrineEntry> _parseV2(contentsMap) {
    final entriesMap = contentsMap['entries'];
    return Map<String, PeregrineEntry>.from(
        entriesMap.map((key, value) => MapEntry(
            key,
            PeregrineEntry(
              date: DateTime.parse(value['date']),
              input: value['input'],
              isEncrypted: value['isEncrypted'],
              tags: List<String>.from(value['tags']),
              mentionedContacts: List<String>.from(value['mentionedContacts']),
            ))));
  }
}
