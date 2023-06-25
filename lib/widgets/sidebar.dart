import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../main.dart';
import 'pret_tag_button.dart';

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
          itemBuilder: (context, index) {
            var currentTag = tags.keys.elementAt(index);
            return PretTagButton(
              isSidebarButton: true,
              color: Color(filter == currentTag ? 0xfff7f2f2 : 0xffdac6b0),
              onPressedCallback: () =>
                  ref.read(entryFilterProvider.notifier).state = currentTag,
              tagName: currentTag,
              tagCount: tags[currentTag],
            );
          }),
    );
  }
}
