import 'package:flutter/material.dart';

import '../config.dart';
import 'pret_card.dart';

class PretTagButton extends StatelessWidget {
  final bool isSidebarButton;
  final Color color;
  final void Function() onPressedCallback;
  final String tagName;
  final int? tagCount;

  const PretTagButton({
    super.key,
    required this.isSidebarButton,
    required this.color,
    required this.onPressedCallback,
    required this.tagName,
    this.tagCount,
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
        boxShadow: isSidebarButton ? null : Config.lightShadow,
        child: !isSidebarButton
            ? Text(tagName)
            : Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        tagName,
                      )),
                  Text(textAlign: TextAlign.right, tagCount.toString()),
                ],
              ),
      ),
    );
  }
}
