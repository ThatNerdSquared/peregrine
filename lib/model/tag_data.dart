import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../format_utils.dart';
import 'json_backend.dart';

class TagsList extends StateNotifier<Map<String, int>> {
  TagsList({Map<String, int>? initialTags})
      : super(initialTags ?? <String, int>{});

  void readTags() async {
    state = await JsonBackend().readTagsFromJson();
  }

  Future<void> _writeTags() async {
    await JsonBackend().writeTagsToJson(state);
  }

  Future<void> scanForTags(String input) async {
    // NOTE: deduplicate w json_backend
    var foundTags = findTags(input);
    for (final tag in foundTags) {
      if (state[tag] != null) {
        state[tag] = state[tag]! + 1;
      } else {
        state[tag] = 1;
      }
    }
    final sortedEntries = state.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    state = {for (final entry in sortedEntries) entry.key: entry.value};
    await _writeTags();
  }
}
