import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

class PeregrineAppBar extends ConsumerWidget {
  final FocusNode searchBoxFocusNode;

  const PeregrineAppBar({
    super.key,
    required this.searchBoxFocusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filter = ref.watch(entryFilterProvider);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: PretConfig.thinBorderRounding,
          bottomRight: PretConfig.thinBorderRounding,
        ),
        boxShadow: [PretConfig.defaultShadow],
        color: Color(0xffb69d7c),
      ),
      margin: const EdgeInsets.only(
        left: PretConfig.preserveShadowSpacing,
        right: PretConfig.preserveShadowSpacing,
      ),
      padding: const EdgeInsets.all(PretConfig.minElementSpacing),
      child: Row(children: [
        Icon(
          filter.icon,
          // yes, i know this is a magic number
          // at some point i will standardize the typography
          // it'll be fine
          size: 20,
        ),
        const Padding(
            padding: EdgeInsets.only(right: PretConfig.thinElementSpacing)),
        Expanded(
            flex: 2,
            child: Text(
              filter.name,
              style: Theme.of(context).textTheme.titleMedium,
            )),
        IconButton.filled(
          style: IconButton.styleFrom(
              iconSize: 20,
              minimumSize: const Size(36, 36),
              maximumSize: const Size(36, 36),
              backgroundColor: const Color(0xffdac6b0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(PretConfig.thinBorderRounding),
              )),
          onPressed: () =>
              ref.read(isLocked.notifier).update((state) => !state),
          icon: Icon(
            ref.watch(isLocked) ? Icons.lock : Icons.lock_open_rounded,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: PretConfig.minElementSpacing),
        ),
        Expanded(
            flex: 2,
            child: TextFormField(
              style: const TextStyle(inherit: true, fontSize: 15),
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(PretConfig.thinElementSpacing),
                  border: OutlineInputBorder(
                      borderRadius: PretConfig.thinBorderRadius),
                  hintText: 'Search...'),
              focusNode: searchBoxFocusNode,
              onChanged: (value) =>
                  ref.read(entryFilterProvider.notifier).addSearch(value),
            ))
      ]),
    );
  }
}
