import 'dart:io';

import 'package:flutter/material.dart';

import '../config.dart';
import 'splitview.dart';

enum BarType { left, right, mobile }

class PretMainView extends StatelessWidget {
  final Widget mainView;
  final Widget leftSidebar;
  final Color barColor;

  const PretMainView({
    super.key,
    required this.mainView,
    required this.leftSidebar,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return PretDesktopBarWrapper(
        sidebar: leftSidebar,
        barType: BarType.mobile,
        barColor: barColor,
      );
    } else {
      return SplitView(
        axis: Axis.horizontal,
        providedFirstFraction: 0.3,
        child1: PretDesktopBarWrapper(
          sidebar: leftSidebar,
          barType: BarType.left,
          barColor: barColor,
        ),
        child2: mainView,
      );
    }
  }
}

class PretDesktopBarWrapper extends StatelessWidget {
  final Widget sidebar;
  final BarType barType;
  final Color barColor;

  const PretDesktopBarWrapper({
    super.key,
    required this.sidebar,
    required this.barType,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            borderRadius: switch (barType) {
              BarType.left => const BorderRadius.only(
                  topRight: Config.defaultBorderRounding,
                  bottomRight: Config.defaultBorderRounding,
                ),
              BarType.right => const BorderRadius.only(
                  topLeft: Config.defaultBorderRounding,
                  bottomLeft: Config.defaultBorderRounding,
                ),
              BarType.mobile => null,
            },
            color: barColor,
            boxShadow: const [Config.defaultShadow],
          ),
          padding: const EdgeInsets.only(
            top: Config.titleBarSafeArea,
          ),
          child: sidebar),
    );
  }
}
