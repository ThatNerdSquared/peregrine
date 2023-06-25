import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import '../vendor/latex.dart';
import 'pret_card.dart';
import 'pret_tag_button.dart';

class EntryListView extends ConsumerStatefulWidget {
  const EntryListView({super.key});

  @override
  EntryListViewState createState() => EntryListViewState();
}

class EntryListViewState extends ConsumerState<EntryListView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var entries = ref.watch(filteredListProvider).keys.toList();
    return Column(children: [
      const Padding(
          padding: EdgeInsets.only(
        top: Config.defaultElementSpacing,
      )),
      Expanded(
          flex: 3,
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: ((context, index) {
              var entryId = entries[index];
              var entry = ref.watch(
                  entryListProvider.select((entryList) => entryList[entryId]!));
              return Padding(
                  padding: const EdgeInsets.only(
                    left: Config.preserveShadowSpacing,
                    right: Config.preserveShadowSpacing,
                  ),
                  child: PretCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDate(entry.date)),
                            Text(formatTime(entry.date)),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: Config.defaultElementSpacing),
                        ),
                        Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...MarkdownGenerator(
                                  generators: [latexGenerator],
                                  inlineSyntaxes: [LatexSyntax()],
                                  linesMargin: const EdgeInsets.all(0),
                                  config: MarkdownConfig(configs: [
                                    ImgConfig(builder: (url, attributes) {
                                      if (url.contains(
                                          r'data:image/png;base64,')) {
                                        return Image.memory(base64Decode(
                                            url.replaceAll(
                                                'data:image/png;base64,', '')));
                                      } else {
                                        return Image.network(url);
                                      }
                                    })
                                  ]),
                                ).buildWidgets(stripTagOnlyLines(entry.input)),
                                Wrap(
                                    children: entry.tags
                                        .map((tag) => PretTagButton(
                                            isSidebarButton: false,
                                            color: Colors.pink[100]!,
                                            onPressedCallback: () => ref
                                                .read(entryFilterProvider
                                                    .notifier)
                                                .state = tag,
                                            tagName: tag))
                                        .toList())
                              ]),
                        ),
                      ],
                    ),
                  ));
            }),
          )),
      Padding(
          padding: const EdgeInsets.all(Config.defaultElementSpacing),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              child: CallbackShortcuts(
                  bindings: <ShortcutActivator, VoidCallback>{
                    const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                        () {
                      ref
                          .read(entryListProvider.notifier)
                          .addNewEntry(_controller.text);
                      _controller.text = '';
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [Config.defaultShadow],
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: Config.defaultBorderRadius,
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: Config.defaultBorderRadius,
                        ),
                        hintText: 'Start a new entry...',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _controller,
                    ),
                  ))))
      // )
    ]);
  }
}
