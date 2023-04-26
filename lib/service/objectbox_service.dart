import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';

class ObjectBoxService {
  late final Store store;
  static ObjectBoxService? _instance;

  ObjectBoxService._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<ObjectBoxService> create() async {
    if (_instance != null) {
      return _instance!;
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
      final store =
          await openStore(directory: p.join(docsDir.path, "hestatistics"));
      _instance = ObjectBoxService._create(store);
      return _instance!;
    }
  }
}
