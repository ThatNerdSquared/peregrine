import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_context_menu/super_context_menu.dart' as scm;

import 'export_utils.dart';
import 'model/entry_data.dart';
import 'model/tag_data.dart';
import 'widgets/confirmation_modal.dart';

scm.Menu buildTagButtonContextMenu(
  BuildContext context,
  String tagName,
  PeregrineTag tagInfo,
  Function(String) autoEncryptToggleCallback,
  List<PeregrineEntry> entries,
  void Function(String) stripTagFromEntriesCallback,
  void Function(String) deleteTagCallback,
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
        scm.MenuAction(
            title: 'Delete Tag',
            image: scm.MenuImage.icon(Icons.delete),
            attributes: const scm.MenuActionAttributes(
              destructive: true,
            ),
            callback: () async {
              final confirmation = await showModalBottomSheet<bool>(
                context: context,
                isDismissible: false,
                builder: (context) => ConfirmationModal(count: tagInfo.count),
              );
              // TODO: why is this nullable?
              if (confirmation != null && confirmation) {
                stripTagFromEntriesCallback(tagName);
                deleteTagCallback(tagName);
              }
            })
      ],
    );

scm.Menu buildEntryCardContextMenu({
  required String entryId,
  required bool isEncrypted,
  required VoidCallback toggleEncryptCallback,
  required Function(String) addAncestorCallback,
}) =>
    scm.Menu(
      children: [
        scm.MenuAction(
          title: 'Add as ancestor',
          callback: () => addAncestorCallback(entryId),
        ),
        scm.MenuAction(
          title: 'Copy Entry URL',
          callback: () => Clipboard.setData(ClipboardData(text: 'peregrine://peregrine/entry/$entryId')),
        ),
        scm.MenuAction(
          title: isEncrypted ? 'Decrypt Entry' : 'Encrypt Entry',
          callback: () => !isEncrypted ? toggleEncryptCallback() : null,
        )
      ],
    );
