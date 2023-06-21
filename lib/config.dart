import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Config {
  static const defaultBorderRounding = Radius.circular(20);
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(defaultBorderRounding);
  static const double defaultElementSpacing = 15.0;
  static const double preserveShadowSpacing = defaultElementSpacing + 2;
  static const double titleBarSafeArea = defaultElementSpacing * 2;
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color.fromRGBO((0), 0, 0, 0.20),
    offset: Offset(0, 4),
    blurRadius: 20.0,
  );

  Future<String> get logFilePath async {
    return p.join(
      (await getApplicationSupportDirectory()).toString(),
      'peregrinelog.json',
    );
  }
}
