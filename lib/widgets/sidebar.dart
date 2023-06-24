import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'pret_card.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider);
    final filter = ref.watch(entryFilterProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffb69d7c),
        borderRadius: BorderRadius.only(
          topRight: Config.defaultBorderRounding,
          bottomRight: Config.defaultBorderRounding,
        ),
        boxShadow: [Config.defaultShadow],
      ),
      padding: const EdgeInsets.only(
        top: Config.titleBarSafeArea,
        left: Config.defaultElementSpacing,
        right: Config.defaultElementSpacing,
      ),
      child: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) => TextButton(
            onPressed: () => ref.read(entryFilterProvider.notifier).state =
                tags.keys.elementAt(index),
            child: PretCard(
              color: filter == tags.keys.elementAt(index)
                  ? const Color(0xffb69d7c)
                  : null,
              padding: Config.tagPadding,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    style: TextStyle(
                      color: filter == tags.keys.elementAt(index)
                          ? Colors.white
                          : null,
                    ),
                    tags.keys.elementAt(index),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  style: TextStyle(
                    color: filter == tags.keys.elementAt(index)
                        ? Colors.white
                        : null,
                  ),
                  tags[tags.keys.elementAt(index)].toString(),
                  textAlign: TextAlign.right,
                ),
              ]),
            )),
      ),
    );
  }
}
