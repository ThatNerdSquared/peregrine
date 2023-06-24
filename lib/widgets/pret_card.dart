import 'package:flutter/material.dart';

import '../config.dart';

class PretCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? color;

  const PretCard({
    super.key,
    required this.child,
    this.padding = Config.defaultElementSpacing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: Config.defaultBorderRadius,
          boxShadow: [Config.defaultShadow],
        ),
        child: Card(
          color: color,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ));
  }
}
