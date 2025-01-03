import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';
import 'package:super_context_menu/super_context_menu.dart' as scm;
import 'package:super_sliver_list/super_sliver_list.dart';

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
  final _listController = ListController();

  void scrollToBottom() => _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );

  @override
  Widget build(BuildContext context) {
    var entries = ref.watch(filteredListProvider).keys.toList();
    final currentJumpId = ref.watch(currentJumpIdProvider);

    Future(() {
      if (currentJumpId != '') {
        ref.read(currentJumpIdProvider.notifier).update((state) => '');
        _listController.jumpToItem(
            index: entries.indexOf(currentJumpId),
            scrollController: _scrollController,
            alignment: 0.5);
      }
    });

    final listView = buildEntryList(entries);
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          bottom: PretConfig.defaultElementSpacing * 6,
        ),
        child: FloatingActionButton(
            backgroundColor: const Color(0xffb69d7c).withValues(alpha: 0.5),
            onPressed: scrollToBottom,
            child: const Icon(Icons.keyboard_double_arrow_down_sharp)),
      ),
      body: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                flex: 9,
                child: Config.isMobile
                    ? CupertinoScrollbar(
                        controller: _scrollController, child: listView)
                    : listView),
            Row(
              children: ref
                  .watch(currentAncestorsProvider)
                  .map((id) => Flexible(
                        child: Tooltip(
                          richMessage: WidgetSpan(
                            child: PeregrineEntryCard(
                              entryId: id,
                              isTopLevel: false,
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: scm.ContextMenuWidget(
                              menuProvider: (_) => scm.Menu(children: [
                                    scm.MenuAction(
                                        title: 'Remove as ancestor',
                                        callback: () => ref
                                            .read(currentAncestorsProvider
                                                .notifier)
                                            .removeAncestor(id))
                                  ]),
                              child: PretCard(
                                child: Text(
                                  id,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ),
                      ))
                  .toList(),
            ),
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
        ],
      ),
    );
  }

  CustomScrollView buildEntryList(List<String> entries) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.all(PretConfig.defaultElementSpacing * 1.5),
        ),
        SuperSliverList.builder(
            listController: _listController,
            itemCount: entries.length,
            itemBuilder: (context, index) =>
                PeregrineEntryCard(entryId: entries[index]))
      ],
    );
  }
}
