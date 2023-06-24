import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'pret_card.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tags = ref.watch(tagsProvider);
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
        itemBuilder: (context, index) => PretCard(
          padding: Config.tagPadding,
          child: Row(children: [
            Expanded(
              flex: 3,
              child: Text(
                tags.keys.elementAt(index),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              tags[tags.keys.elementAt(index)].toString(),
              textAlign: TextAlign.right,
            ),
          ]),
        ),
      ),
    );
  }
}
