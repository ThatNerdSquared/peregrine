import 'dart:io';

import 'package:path/path.dart' as p;

import 'main.dart';

class Config {
  Config._();

  static String get logFilePath {
    return p.join(
      platformAppSupportDir,
      'peregrinelog.json',
    );
  }

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
}
