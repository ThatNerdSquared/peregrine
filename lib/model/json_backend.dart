import 'dart:convert';
import 'dart:io';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'entry_data.dart';

class JsonBackend {
  void _checkForLogFile() async {
    final logFile = File(await Config().logFilePath);
    var doesFileExist = await logFile.exists();
    if (!doesFileExist) {
      logFile.create();
    }
  }

  void writeJsonToFile(Map<String, dynamic> mappifiedLog) async {
    _checkForLogFile();
    final logFile = File(await Config().logFilePath);
    const encoder = JsonEncoder.withIndent('    ');
    final stringifiedLog = encoder.convert(mappifiedLog);
    logFile.writeAsString(stringifiedLog);
  }

  Future<Map<String, PeregrineEntry>> readEntriesFromJson() async {
    final logFile = File(await Config().logFilePath);
    final file = logFile;
    final contents = await file.readAsString();
    final contentsMap = jsonDecode(contents);
    if (contentsMap is List) {
      return _parseV1(contentsMap);
    }
    return _parseV2(contentsMap);
  }

  Map<String, PeregrineEntry> _parseV1(contentsMap) {
    return contentsMap.map((value) => MapEntry(
        uuID.v4(),
        PeregrineEntry(
          date: value['date'],
          input: value['input'],
          isEncrypted: value['encrypted'],
          tags: findTags(value['input']),
          mentionedContacts: findContacts(value['input']),
        )));
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
