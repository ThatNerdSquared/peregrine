import 'dart:io';

import 'package:flutter/material.dart';

import 'splitview.dart';

class PretMainView extends StatelessWidget {
  final Widget mainView;
  final Widget leftSidebar;

  const PretMainView({
    super.key,
    required this.mainView,
    required this.leftSidebar,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(child: mainView);
    } else {
      return SplitView(
        axis: Axis.horizontal,
        providedFirstFraction: 0.3,
        child1: leftSidebar,
        child2: mainView,
      );
    }
  }
}
