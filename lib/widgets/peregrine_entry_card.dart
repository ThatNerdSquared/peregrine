import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../format_utils.dart';
import '../main.dart';
import '../vendor/latex.dart';

class PeregrineEntryCard extends ConsumerWidget {
  const PeregrineEntryCard({
    super.key,
    required this.entryId,
  });

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var entry =
        ref.watch(entryListProvider.select((entryList) => entryList[entryId]!));
    return Padding(
        padding: const EdgeInsets.only(
          left: PretConfig.preserveShadowSpacing,
          right: PretConfig.preserveShadowSpacing,
        ),
        child: PretCard(
          padding: const EdgeInsets.only(
            left: PretConfig.defaultElementSpacing,
            right: PretConfig.defaultElementSpacing,
            bottom: PretConfig.defaultElementSpacing,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: PretConfig.thinElementSpacing),
            // this row is useless, but taking it out gives a box drawing error,
            // i think i'm doing something wrong
            child: Row(
              children: [
                Expanded(
                  child: entry.isEncrypted && ref.watch(isLocked)
                      ? const Text.rich(TextSpan(text: '🔒', children: [
                          TextSpan(
                            text:
                                'This entry is encrypted. Unlock the app to view.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ]))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text('${formatDate(entry.date)} '),
                                      Text(formatTime(entry.date)),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.all(
                                          PretConfig.minElementSpacing)),
                                  Expanded(
                                    child: Wrap(
                                        spacing: PretConfig.minElementSpacing,
                                        runSpacing:
                                            PretConfig.minElementSpacing,
                                        alignment: WrapAlignment.end,
                                        children: entry.tags
                                            .map((tag) => OutlinedButton(
                                                // color: Colors.pink[100]!,
                                                style: const ButtonStyle(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    shape:
                                                        MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius: PretConfig
                                                            .thinBorderRadius,
                                                      ),
                                                    ),
                                                    padding:
                                                        MaterialStatePropertyAll(
                                                      EdgeInsets.all(
                                                        PretConfig
                                                                .minElementSpacing /
                                                            2,
                                                      ),
                                                    )),
                                                onPressed: () => ref
                                                    .read(entryFilterProvider
                                                        .notifier)
                                                    .setTagFilter(tag),
                                                child: Text(
                                                  '#$tag',
                                                )))
                                            .toList()),
                                  ),
                                ],
                              ),
                              const Divider(),
                              ...MarkdownGenerator(
                                generators: [latexGenerator],
                                inlineSyntaxList: [LatexSyntax()],
                                linesMargin: const EdgeInsets.all(0),
                              ).buildWidgets(
                                stripTagOnlyLines(entry.input),
                                config: MarkdownConfig(configs: [
                                  ImgConfig(builder: (url, attributes) {
                                    if (url
                                        .contains(r'data:image/png;base64,')) {
                                      return Image.memory(base64Decode(
                                          url.replaceAll(
                                              'data:image/png;base64,', '')));
                                    } else {
                                      return Image.network(url);
                                    }
                                  }),
                                  const CodeConfig(
                                    style: TextStyle(
                                      fontFamily: 'Menlo',
                                      backgroundColor: Color(0xffeff1f3),
                                    ),
                                  ),
                                ]),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: PretConfig.minElementSpacing,
                                ),
                              ),
                            ]),
                ),
              ],
            ),
          ),
        ));
  }
}
