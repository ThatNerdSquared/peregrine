import 'package:flutter/material.dart';

import '../config.dart';

class PretCard extends StatelessWidget {
  final Widget child;
  final double padding;

  const PretCard(
      {super.key,
      required this.child,
      this.padding = Config.defaultElementSpacing});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: Config.defaultBorderRadius,
          boxShadow: [Config.defaultShadow],
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ));
  }
}
