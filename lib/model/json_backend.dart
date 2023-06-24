import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'entry_data.dart';

class JsonBackend {
  static const JsonEncoder encoder = JsonEncoder.withIndent('    ');

  void _checkForLogFile() async {
    final logFile = File(await Config().logFilePath);
    final doesFileExist = await logFile.exists();
    if (!doesFileExist) {
      logFile.create();
    }
  }

  dynamic _loadJson() async {
    final logFile = File(await Config().logFilePath);
    final contents = await logFile.readAsString();
    return jsonDecode(contents);
  }

  void _putJson(String stringifiedLog) async {
    final logFile = File(await Config().logFilePath);
    logFile.writeAsString(stringifiedLog);
  }

  void writeEntriesToJson(
    Map<String, Map<String, dynamic>> mappifiedLog,
  ) async {
    _checkForLogFile();
    var rawLog = await _loadJson();
    rawLog['entries'] = mappifiedLog;
    final stringifiedLog = encoder.convert(rawLog);
    _putJson(stringifiedLog);
  }

  void writeTagsToJson(List<String> tags) async {
    _checkForLogFile();
    var rawLog = await _loadJson();
    rawLog['tags'] = tags;
    final stringifiedLog = encoder.convert(rawLog);
    _putJson(stringifiedLog);
  }

  Future<Map<String, PeregrineEntry>> readEntriesFromJson() async {
    final logFile = File(await Config().logFilePath);
    final contents = await logFile.readAsString();
    final contentsMap = jsonDecode(contents);
    if (contentsMap is List) {
      return _parseV1(contentsMap);
    }
    return _parseV2(contentsMap);
  }

  Future<Map<String, int>> readTagsFromJson() async {
    final logFile = File(await Config().logFilePath);
    final contents = await logFile.readAsString();
    final contentsMap = jsonDecode(contents);
    var tags = <String, int>{};
    if (contentsMap is! List && contentsMap['tags'] != null) {
      tags = {for (final item in contentsMap['tags']) item: 0};
    }
    final items = await readEntriesFromJson();
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
    return Map<String, PeregrineEntry>.from({
      for (final value in contentsMap)
        uuID.v4(): PeregrineEntry(
          date: DateTime.parse(value['date']),
          input: value['input'],
          isEncrypted: value['encrypted'] ?? false,
          tags: findTags(value['input']),
          mentionedContacts: findContacts(value['input']),
        )
    });
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
