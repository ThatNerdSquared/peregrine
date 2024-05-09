import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentAncestors extends StateNotifier<List<String>> {
  CurrentAncestors() : super([]);

  void addAncestor(String ancestorId) {
    if (state.contains(ancestorId)) return;
    state = [...state, ancestorId];
  }

  void removeAncestor(String ancestorId) {
    state = state.where((id) => id != ancestorId).toList();
  }

  void clearAncestors() {
    state = [];
  }
}
