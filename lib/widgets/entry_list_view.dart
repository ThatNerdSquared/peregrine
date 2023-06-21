import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: Config.defaultElementSpacing,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDate(entry.date)),
                            Text(formatTime(entry.date)),
                          ],
                        ),
                        Text(entry.input),
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
