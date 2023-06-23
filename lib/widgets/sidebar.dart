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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tags
            .map((tag) => PretCard(
                  padding: Config.tagPadding,
                  child: Text(tag),
                ))
            .toList(),
      ),
    );
  }
}
