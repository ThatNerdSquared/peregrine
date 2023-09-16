import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format_utils.dart';
import 'json_backend.dart';

class TagsList extends StateNotifier<Map<String, PeregrineTag>> {
  TagsList({Map<String, PeregrineTag>? initialTags})
      : super(initialTags ?? <String, PeregrineTag>{}) {
    readTags();
  }

  void readTags() {
    state = JsonBackend().readTagsFromJson();
  }

  void _writeTags() {
    JsonBackend().writeTagsToJson(state);
  }

  void scanForTags(String input) {
    var foundTags = findTags(input);
    for (final tag in foundTags) {
      if (state[tag] != null) {
        state[tag] = PeregrineTag(
          autoEncrypt: state[tag]!.autoEncrypt,
          count: state[tag]!.count + 1,
        );
      } else {
        state[tag] = const PeregrineTag(
          autoEncrypt: false,
          count: 1,
        );
      }
    }
    state = sortTags(state);
    _writeTags();
  }
Map<String, PeregrineTag> sortTags(Map<String, PeregrineTag> tags) {
  final sortedTagsList = tags.entries.toList()
    ..sort((a, b) => b.value.count.compareTo(a.value.count));
  return {for (final mapEntry in sortedTagsList) mapEntry.key: mapEntry.value};
}

@immutable
class PeregrineTag {
  final bool autoEncrypt;
  final int count;

  const PeregrineTag({
    required this.autoEncrypt,
    required this.count,
  });

  Map<String, dynamic> toJson() {
    return {
      'autoEncrypt': autoEncrypt,
      'count': count,
    };
  }
}
