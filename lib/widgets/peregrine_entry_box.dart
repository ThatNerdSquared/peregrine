import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

class PeregrineEntryBox extends ConsumerStatefulWidget {
  final FocusNode entryBoxFocusNode;

  const PeregrineEntryBox({
    super.key,
    required this.entryBoxFocusNode,
  });

  @override
  PeregrineEntryBoxState createState() => PeregrineEntryBoxState();
}

class PeregrineEntryBoxState extends ConsumerState<PeregrineEntryBox> {
  final TextEditingController _controller = TextEditingController();

  void submitNewLogEntry() {
    if (_controller.text.trim() == '') return;
    ref.read(entryListProvider.notifier).addNewEntry(
          input: _controller.text,
          ancestors: ref.read(currentAncestorsProvider),
        );
    _controller.text = '';
    ref.read(currentAncestorsProvider.notifier).clearAncestors();
  }

  void insertIndent() {
    final cursor = _controller.selection.base.offset;
    final beforeCursor = _controller.text.substring(0, cursor);
    final afterCursor = _controller.text.substring(cursor);
    // TODO: this should probably be abstracted into a setting
    _controller.text = '$beforeCursor    $afterCursor';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        child: CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(
              LogicalKeyboardKey.enter,
              meta: true,
            ): submitNewLogEntry,
            const SingleActivator(LogicalKeyboardKey.tab): insertIndent
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
                  focusNode: entryBoxFocusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _controller,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(PretConfig.minElementSpacing),
            ),
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
                          BorderRadius.all(PretConfig.thinBorderRounding),
                    )),
                onPressed: submitNewLogEntry,
                icon: Icon(
                  Icons.move_to_inbox_rounded,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            )
          ]),
        ));
  }
}
