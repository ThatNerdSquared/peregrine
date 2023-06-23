import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'json_backend.dart';

class TagsList extends StateNotifier<List<String>> {
  TagsList({List<String>? initialTags}) : super(initialTags ?? []);

  void readTags() async {
    try {
      state = await JsonBackend().readTagsFromJson();
    } catch (_) {
      state = ['whee', 'whoo', 'hahahah!!!'];
    }
  }
}
