import 'package:flutter/material.dart';

class DragHandler {
  final double initialHeightFactor;
  final double maxHeightFactor;

  DragHandler({required this.initialHeightFactor, required this.maxHeightFactor});

  double handleDragUpdate({
    required DragUpdateDetails details,
    required BuildContext context,
    required double currentHeight,
  }) {
    final double minHeight = initialHeightFactor * MediaQuery.of(context).size.height;
    final double maxHeight = maxHeightFactor * MediaQuery.of(context).size.height;

    return (currentHeight - details.delta.dy).clamp(minHeight, maxHeight);
  }

  Animation<double> handleDragEnd({
    required AnimationController animationController,
    required BuildContext context,
    required double currentHeight,
  }) {
    final double minHeight = initialHeightFactor * MediaQuery.of(context).size.height;

    return Tween<double>(begin: currentHeight, end: minHeight).animate(animationController);
  }
}
