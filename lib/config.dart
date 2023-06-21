import 'package:flutter/material.dart';

class Config {
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(20));
  static const double defaultElementSpacing = 15.0;
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color.fromRGBO((0), 0, 0, 0.20),
    offset: Offset(0, 4),
    blurRadius: 20.0,
  );
}
