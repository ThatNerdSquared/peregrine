import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../format_utils.dart';
import '../main.dart';
import '../vendor/latex.dart';

class PeregrineEntryCard extends ConsumerStatefulWidget {
  const PeregrineEntryCard({
    super.key,
    required this.entryId,
    this.isNested = false,
  });

  final String entryId;
  final bool isNested;

  @override
  ConsumerState<PeregrineEntryCard> createState() => _PeregrineEntryCardState();
}

class _PeregrineEntryCardState extends ConsumerState<PeregrineEntryCard> {
  bool _ancestorsShown = false;
  bool _descendantsShown = false;

  @override
  Widget build(BuildContext context) {
    var entry = ref.watch(
        entryListProvider.select((entryList) => entryList[widget.entryId]!));
    return Padding(
        padding: const EdgeInsets.only(
          left: PretConfig.preserveShadowSpacing,
          right: PretConfig.preserveShadowSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ancestorsShown
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 42.0,
                      top: PretConfig.defaultElementSpacing,
                    ),
                    padding: const EdgeInsets.only(
                      top: PretConfig.preserveShadowSpacing,
                      bottom: PretConfig.thinElementSpacing,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        left: BorderSide(width: 1.0, color: Colors.grey),
                        right: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: PretConfig.defaultBorderRounding,
                        topRight: PretConfig.defaultBorderRounding,
                      ),
                    ),
                    child: Column(
                      children: entry.ancestors
                          .map((id) => PeregrineEntryCard(
                                entryId: id,
                                isNested: true,
                              ))
                          .toList(),
                    ),
                  )
                : Container(),
            PretCard(
              padding: EdgeInsets.only(
                top: PretConfig.thinElementSpacing,
                left: PretConfig.defaultElementSpacing,
                right: PretConfig.defaultElementSpacing,
                bottom: entry.isEncrypted && ref.watch(isLocked)
                    ? PretConfig.thinElementSpacing
                    : PretConfig.defaultElementSpacing,
              ),
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
                          entry.ancestors.isNotEmpty && widget.isNested
                              ? Text.rich(
                                  TextSpan(
                                    text: '${entry.ancestors.length} ancestors',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => setState(() {
                                            _ancestorsShown = !_ancestorsShown;
                                          }),
                                  ),
                                )
                              : Container(),
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
                                    PretConfig.minElementSpacing),
                              ),
                              Expanded(
                                child: Wrap(
                                    spacing: PretConfig.minElementSpacing,
                                    runSpacing: PretConfig.minElementSpacing,
                                    alignment: WrapAlignment.end,
                                    children: entry.tags
                                        .map((tag) => OutlinedButton(
                                            style: const ButtonStyle(
                                                minimumSize:
                                                    MaterialStatePropertyAll(
                                                  Size(32, 32),
                                                ),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: PretConfig
                                                        .thinBorderRadius,
                                                  ),
                                                ),
                                                padding:
                                                    MaterialStatePropertyAll(
                                                  EdgeInsets.all(
                                                      //PretConfig.minElementSpacing / 2,
                                                      PretConfig
                                                          .minElementSpacing),
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
                          const Padding(
                            padding: EdgeInsets.only(
                                top: PretConfig.minElementSpacing),
                          ),
                          ...MarkdownGenerator(
                            generators: [latexGenerator],
                            inlineSyntaxList: [LatexSyntax()],
                            linesMargin: const EdgeInsets.all(0),
                          ).buildWidgets(
                            stripTagOnlyLines(entry.input),
                            config: MarkdownConfig(configs: [
                              ImgConfig(builder: (url, attributes) {
                                if (url.contains(r'data:image/png;base64,')) {
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
                          entry.descendants.isNotEmpty && widget.isNested
                              ? Text.rich(
                                  TextSpan(
                                    text:
                                        '${entry.descendants.length} descendants',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => setState(() {
                                            _descendantsShown =
                                                !_descendantsShown;
                                          }),
                                  ),
                                )
                              : Container(),
                        ]),
            ),
            _descendantsShown
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 42.0,
                      bottom: PretConfig.defaultElementSpacing,
                    ),
                    padding: const EdgeInsets.only(
                      top: PretConfig.thinElementSpacing,
                      bottom: PretConfig.preserveShadowSpacing,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                        left: BorderSide(width: 1.0, color: Colors.grey),
                        right: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: PretConfig.defaultBorderRounding,
                        bottomRight: PretConfig.defaultBorderRounding,
                      ),
                    ),
                    child: Column(
                      children: entry.descendants
                          .map((id) => PeregrineEntryCard(
                                entryId: id,
                                isNested: true,
                              ))
                          .toList(),
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
