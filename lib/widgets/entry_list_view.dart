import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/config/all.dart';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import 'pret_card.dart';

class EntryListView extends ConsumerStatefulWidget {
  const EntryListView({super.key});

  @override
  EntryListViewState createState() => EntryListViewState();
}

class EntryListViewState extends ConsumerState<EntryListView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var entries = ref.watch(entryListProvider).keys.toList();
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
                          //   child: MarkdownBody(
                          // data: entry.input,
                          // onTapLink: (text, href, title) =>
                          //     launchUrl(Uri.parse(href!)),)
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: MarkdownGenerator(
                                linesMargin: const EdgeInsets.all(0),
                                // config: MarkdownConfig(configs: [
                                //   const ImgConfig(
                                //       builder: (url, attributes) =>
                                //           Image.memory(bytes))
                                // ]),
                              ).buildWidgets(entry.input)),
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
