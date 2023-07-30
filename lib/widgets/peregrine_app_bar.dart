import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pret_a_porter/pret_a_porter.dart';

import '../main.dart';

class PeregrineAppBar extends ConsumerWidget {
  const PeregrineAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filter = ref.watch(entryFilterProvider);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: PretConfig.defaultBorderRounding,
          bottomRight: PretConfig.defaultBorderRounding,
        ),
        boxShadow: [PretConfig.intenseShadow],
        color: Color(0xffb69d7c),
      ),
      margin: const EdgeInsets.only(
        left: PretConfig.preserveShadowSpacing,
        right: PretConfig.preserveShadowSpacing,
      ),
      padding: const EdgeInsets.all(PretConfig.tagPadding),
      child: Row(children: [
        Icon(
          filter.icon,
          // yes, i know this is a magic number
          // at some point i will standardize the typography
          // it'll be fine
          size: 30,
        ),
        const Padding(
            padding: EdgeInsets.only(right: PretConfig.defaultElementSpacing)),
        Expanded(
            flex: 2,
            child: Text(
              filter.name,
              style: Theme.of(context).textTheme.titleLarge,
            )),
        Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.all(PretConfig.defaultElementSpacing),
                  border: OutlineInputBorder(
                      borderRadius: PretConfig.defaultBorderRadius),
                  hintText: 'Search...'),
              onChanged: (value) =>
                  ref.read(entryFilterProvider.notifier).addSearch(value),
            ))
      ]),
    );
  }
}
