import 'package:flutter/material.dart';

import '../config.dart';

class PretCard extends StatelessWidget {
  final Widget child;

  const PretCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: Config.defaultBorderRadius,
          boxShadow: [Config.defaultShadow],
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Config.defaultElementSpacing),
            child: child,
          ),
        ));
  }
}
