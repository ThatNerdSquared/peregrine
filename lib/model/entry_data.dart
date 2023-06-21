import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class PeregrineEntryList extends StateNotifier<Map<String, PeregrineEntry>> {
  PeregrineEntryList({
    Map<String, PeregrineEntry>? initialEntries,
  }) : super(initialEntries ?? <String, PeregrineEntry>{});

  void addNewEntry(String input) {
    var findTags = RegExp(r'#[^\s]+');
    var findContacts = RegExp(r'@[^\s]+');
    var tags = findTags.allMatches(input).toList().map((e) => e[0]!).toList();
    var mentionedContacts =
        findContacts.allMatches(input).map((e) => e[0]!).toList();
    state = {
      ...state,
      uuID.v4(): PeregrineEntry(
        date: DateTime.now(),
        input: input,
        encrypted: false,
        tags: tags,
        mentionedContacts: mentionedContacts,
      ),
    };
  }
}

@immutable
class PeregrineEntry {
  final DateTime date;
  final String input;
  final bool encrypted;
  final List<String> tags;
  final List<String> mentionedContacts;

  const PeregrineEntry({
    required this.date,
    required this.input,
    required this.encrypted,
    required this.tags,
    required this.mentionedContacts,
  });
}
