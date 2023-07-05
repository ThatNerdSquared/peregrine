import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../config.dart';
import '../format_utils.dart';
import '../main.dart';
import '../vendor/latex.dart';
import 'pret_card.dart';
import 'pret_tag_button.dart';

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
                padding: EdgeInsets.only(left: Config.defaultElementSpacing),
              ),
              Expanded(
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
                            if (url.contains(r'data:image/png;base64,')) {
                              return Image.memory(base64Decode(url.replaceAll(
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
                                  color: Colors.pink[100]!,
                                  onPressedCallback: () => ref
                                      .read(entryFilterProvider.notifier)
                                      .setTagFilter(tag),
                                  tagName: tag))
                              .toList())
                    ]),
              ),
            ],
          ),
        ));
  }
}
