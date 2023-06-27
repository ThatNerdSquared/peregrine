import 'package:flutter/material.dart';

import '../config.dart';
import 'pret_card.dart';

class PretTagButton extends StatelessWidget {
  final Color color;
  final void Function() onPressedCallback;
  final String tagName;

  const PretTagButton({
    super.key,
    required this.color,
    required this.onPressedCallback,
    required this.tagName,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style:
          const ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
      onPressed: onPressedCallback,
      child: PretCard(
          color: color,
          borderRadius: Config.tagBorderRadius,
          padding: Config.tagPadding,
          boxShadow: Config.lightShadow,
          child: Text(tagName)),
    );
  }
}
