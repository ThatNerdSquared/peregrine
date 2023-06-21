import 'package:flutter/material.dart';

import '../config.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Text('whee'),
    );
  }
}
