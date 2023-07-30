import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

class PeregrineEntryBox extends ConsumerStatefulWidget {
  const PeregrineEntryBox({
    super.key,
  });

  @override
  PeregrineEntryBoxState createState() => PeregrineEntryBoxState();
}

class PeregrineEntryBoxState extends ConsumerState<PeregrineEntryBox> {
  final TextEditingController _controller = TextEditingController();

  void submitNewLogEntry() {
    if (_controller.text.trim() == '') return;
    ref.read(entryListProvider.notifier).addNewEntry(_controller.text);
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                  submitNewLogEntry
            },
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [PretConfig.defaultShadow],
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: PretConfig.defaultBorderRadius,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: PretConfig.defaultBorderRadius,
                      ),
                      hintText: 'Start a new entry...',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _controller,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(PretConfig.tilePadding)),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: PretConfig.defaultBorderRadius,
                  boxShadow: [PretConfig.defaultShadow],
                ),
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffb69d7c),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(PretConfig.tagBorderRounding),
                      )),
                  onPressed: submitNewLogEntry,
                  icon: Icon(
                    Icons.move_to_inbox_rounded,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              )
              // )
            ])));
  }
}
