import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
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
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.enter, meta: true): () {
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
            )));
  }
}
