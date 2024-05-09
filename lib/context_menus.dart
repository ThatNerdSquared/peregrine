import 'package:pret_a_porter/pret_a_porter.dart';

import 'export_utils.dart';
import 'model/entry_data.dart';
import 'model/tag_data.dart';

Menu buildTagButtonContextMenu(
  String tagName,
  PeregrineTag tagInfo,
  Function(String) autoEncryptToggleCallback,
  List<PeregrineEntry> entries,
) =>
    Menu(
      items: [
        MenuItem.checkbox(
          label: 'Auto Encrypt',
          checked: tagInfo.autoEncrypt,
          onClick: (_) => autoEncryptToggleCallback(tagName),
        ),
        MenuItem.submenu(
          label: 'Export as...',
          submenu: Menu(
            items: [
              MenuItem(
                label: 'Markdown',
                onClick: (_) => exportMarkdown(
                  entries: entries,
                  logName: tagName,
                ),
              ),
            ],
          ),
        )
      ],
    );

Menu buildEntryCardContextMenu({
  required String entryId,
  required Function(String) addAncestorCallback,
}) =>
    Menu(
      items: [
        MenuItem(
          label: 'Add as ancestor',
          onClick: (_) => addAncestorCallback(entryId),
        )
      ],
    );
