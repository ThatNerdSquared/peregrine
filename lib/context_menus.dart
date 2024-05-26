import 'package:super_context_menu/super_context_menu.dart' as scm;

import 'export_utils.dart';
import 'model/entry_data.dart';
import 'model/tag_data.dart';

scm.Menu buildTagButtonContextMenu(
  String tagName,
  PeregrineTag tagInfo,
  Function(String) autoEncryptToggleCallback,
  List<PeregrineEntry> entries,
) =>
    scm.Menu(
      children: [
        scm.MenuAction(
          title: 'Auto Encrypt',
          state: tagInfo.autoEncrypt
              ? scm.MenuActionState.checkOn
              : scm.MenuActionState.checkOff,
          callback: () => autoEncryptToggleCallback(tagName),
        ),
        scm.Menu(
          title: 'Export as...',
          children: [
            scm.MenuAction(
              title: 'Markdown',
              callback: () => exportMarkdown(
                entries: entries,
                logName: tagName,
              ),
            ),
          ],
        ),
      ],
    );

scm.Menu buildEntryCardContextMenu({
  required String entryId,
  required Function(String) addAncestorCallback,
}) =>
    scm.Menu(
      children: [
        scm.MenuAction(
          title: 'Add as ancestor',
          callback: () => addAncestorCallback(entryId),
        )
      ],
    );
