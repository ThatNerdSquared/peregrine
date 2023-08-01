import 'package:path/path.dart' as p;

import 'main.dart';

class Config {
  static const currentSchemaVersion = '2.0.0';

  String get logFilePath {
    return p.join(
      platformAppSupportDir,
      'peregrinelog.json',
    );
  }
}
