import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../config.dart';
import '../main.dart';
import 'peregrine_app_bar.dart';
import 'peregrine_entry_box.dart';
import 'peregrine_entry_card.dart';

class EntryListView extends ConsumerStatefulWidget {
  final FocusNode entryBoxFocusNode;
  final FocusNode searchBoxFocusNode;

  const EntryListView({
    super.key,
    required this.entryBoxFocusNode,
    required this.searchBoxFocusNode,
  });

  @override
  EntryListViewState createState() => EntryListViewState();
}

class EntryListViewState extends ConsumerState<EntryListView> {
  final _scrollController = ScrollController();

  void scrollToBottom() => _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );

  @override
  Widget build(BuildContext context) {
    var entries = ref.watch(filteredListProvider).keys.toList();
    final listView = CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.all(PretConfig.defaultElementSpacing * 1.5),
        ),
        SliverList.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              var entryId = entries[index];
              return PeregrineEntryCard(entryId: entryId);
            })
      ],
    );
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: PretConfig.defaultElementSpacing * 6,
        ),
        child: FloatingActionButton(
            backgroundColor: const Color(0xffb69d7c).withOpacity(0.5),
            onPressed: scrollToBottom,
            child: const Icon(Icons.keyboard_double_arrow_down_sharp)),
      ),
      body: Stack(children: [
        Column(children: [
          Expanded(
              flex: 9,
              child: Config.isMobile
                  ? CupertinoScrollbar(
                      controller: _scrollController, child: listView)
                  : listView),
          Padding(
            padding: const EdgeInsets.all(PretConfig.defaultElementSpacing),
            child: PeregrineEntryBox(
              entryBoxFocusNode: entryBoxFocusNode,
            ),
          ),
        ]),
        PeregrineAppBar(
          searchBoxFocusNode: searchBoxFocusNode,
        ),
      ]),
    );
  }
}
