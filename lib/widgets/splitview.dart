// Heavily modeled after
// https://github.com/flutter/samples/blob/main/desktop_photo_search/material/lib/src/widgets/split.dart#L24
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SplitView extends StatefulWidget {
  final Axis axis;
  final Widget child1;
  final Widget child2;
  final double providedFirstFraction;

  const SplitView({
    super.key,
    required this.axis,
    required this.child1,
    required this.child2,
    providedFirstFraction,
  }) : providedFirstFraction = providedFirstFraction ?? 0.5;

  static const double dividerWidth = 10;
  static const double halfDivider = dividerWidth / 2;

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late double firstSplitFraction;

  double get secondSplitFraction => 1 - firstSplitFraction;
  bool get isHorizontal => widget.axis == Axis.horizontal;

  @override
  void initState() {
    super.initState();
    firstSplitFraction = widget.providedFirstFraction;
  }

  void resizeSplit(DragUpdateDetails details, double axis) {
    final change = isHorizontal ? details.delta.dx : details.delta.dy;
    final changeAsFraction = change / axis;
    setState(() {
      firstSplitFraction =
          (firstSplitFraction + changeAsFraction).clamp(0.0, 1.0);
    });
  }

  Widget _divider(height, width, axis) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) =>
          isHorizontal ? resizeSplit(details, axis) : null,
      onVerticalDragUpdate: (details) =>
          isHorizontal ? null : resizeSplit(details, axis),
      dragStartBehavior: DragStartBehavior.down,
      child: SizedBox(
        width: isHorizontal ? SplitView.dividerWidth : width,
        height: isHorizontal ? height : SplitView.dividerWidth,
        child: const Center(child: Icon(Icons.adjust_rounded)),
      ),
    );
  }

  Widget _assembleSplit(BuildContext context, BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;
    final axis = isHorizontal ? maxWidth : maxHeight;
    final firstSplitSize = (firstSplitFraction * axis)
            .clamp(SplitView.halfDivider, axis - SplitView.halfDivider) -
        SplitView.halfDivider;
    final secondSplitSize = (secondSplitFraction * axis)
            .clamp(SplitView.halfDivider, axis - SplitView.halfDivider) -
        SplitView.halfDivider;

    return Flex(
      direction: widget.axis,
      children: [
        SizedBox(
          width: isHorizontal ? firstSplitSize : maxWidth,
          height: isHorizontal ? maxHeight : firstSplitSize,
          child: widget.child1,
        ),
        _divider(maxHeight, maxWidth, axis),
        SizedBox(
          width: isHorizontal ? secondSplitSize : maxWidth,
          height: isHorizontal ? maxHeight : secondSplitSize,
          child: widget.child2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _assembleSplit);
  }
}
