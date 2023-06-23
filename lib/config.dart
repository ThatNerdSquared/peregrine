import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Config {
  static const defaultBorderRounding = Radius.circular(20);
  static const tagBorderRounding = Radius.circular(10);
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(defaultBorderRounding);
  static const double defaultElementSpacing = 15.0;
  static const double preserveShadowSpacing = defaultElementSpacing + 2;
  static const double titleBarSafeArea = defaultElementSpacing * 2;
  static const double tagPadding = defaultElementSpacing / 3;
  static const BorderRadius tagBorderRadius =
      BorderRadius.all(tagBorderRounding);
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color.fromRGBO((0), 0, 0, 0.20),
    offset: Offset(0, 4),
    blurRadius: 20.0,
  );

  Future<String> get logFilePath async {
    //  I'm aware that according to the `path_provider` docs, we
    // 'should not use this directory for user data files'.
    // HOWEVER: it is one of the few besides documents and temp
    // that are available on all platforms. Will consider
    // changing later.
    return p.join(
      (await getApplicationSupportDirectory()).path,
      'peregrinelog.json',
    );
  }
}
