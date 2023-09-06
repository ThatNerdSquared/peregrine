import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_launcher_icons/utils.dart';

import 'format_utils.dart';
import 'model/entry_data.dart';

List<String> _buildMarkdownFromEntries(
  List<PeregrineEntry> entries,
  String logName,
) {
  var mdList = <String>['# $logName', '\n'];
  for (final entry in entries) {
    mdList.add('## ${formatDate(entry.date)} ${formatTime(entry.date)}\n');
    mdList.add(entry.input);
    mdList.add('\n---\n');
  }
  return mdList;
}

void exportMarkdown({
  required List<PeregrineEntry> entries,
  String logName = 'peregrine-log',
}) async {
  final rawMarkdown = _buildMarkdownFromEntries(entries, logName);
  final outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Export Log',
    fileName: '$logName.md',
  );
  if (outputFile == null) return;
  createFileIfNotExist(outputFile);
  File(outputFile).writeAsStringSync(rawMarkdown.join('\n'));
}
