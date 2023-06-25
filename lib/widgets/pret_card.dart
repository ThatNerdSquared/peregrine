import 'package:flutter/material.dart';

import '../config.dart';

class PretCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxShadow? boxShadow;

  const PretCard({
    super.key,
    required this.child,
    this.padding = Config.defaultElementSpacing,
    this.color,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? Config.defaultBorderRadius,
          boxShadow: [boxShadow ?? Config.defaultShadow],
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
