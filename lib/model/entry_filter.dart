import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _allEntriesFilter = EntryFilter(
    includes: {FilterType.search: ''},
    excludes: {},
    name: 'All Entries',
    icon: Icons.all_inbox_rounded);

class PeregrineEntryFilter extends StateNotifier<EntryFilter> {
  PeregrineEntryFilter({EntryFilter? initialFilter})
      : super(initialFilter ?? _allEntriesFilter);

  void setAllEntriesFilter() {
    state = _allEntriesFilter;
  }

  void setTagFilter(String tag) {
    state = EntryFilter(
        includes: {FilterType.tag: tag},
        excludes: const {},
        name: tag.replaceAll('#', ''),
        icon: Icons.tag_rounded);
  }

  void addSearch(String search) {
    state = EntryFilter(
        includes: {...state.includes, FilterType.search: search},
        excludes: state.excludes,
        name: state.name,
        icon: state.icon);
  }
}

enum FilterType { search, tag, contact }

@immutable
class EntryFilter {
  final Map<FilterType, String> includes;
  final Map<FilterType, String> excludes;
  final String name;
  final IconData icon;

  const EntryFilter(
      {required this.includes,
      required this.excludes,
      required this.name,
      required this.icon});
}
