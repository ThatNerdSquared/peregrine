import 'package:flutter/material.dart';

import '../config.dart';
import 'pret_card.dart';

class PretSidebarButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final int? count;
  final void Function() onPressedCallback;
  final Color color;

  const PretSidebarButton(
      {super.key,
      required this.buttonText,
      required this.icon,
      this.count,
      required this.onPressedCallback,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return PretCard(
        color: color,
        padding: Config.tilePadding,
        child: ListTile(
          dense: true,
          horizontalTitleGap: 10,
          contentPadding: EdgeInsets.zero,
          title: Text(buttonText),
          leading: Icon(icon),
          minVerticalPadding: 0,
          trailing: Text(count.toString()),
          onTap: onPressedCallback,
        ));
  }
}
