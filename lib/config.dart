import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Config {
  static const currentSchemaVersion = '2.0.0';

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
