import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';

// class ObjectBoxService {
//   late final Store store;
//   static ObjectBoxService? _instance;
//
//   ObjectBoxService._create(this.store) {
//     // Add any additional setup code, e.g. build queries.
//   }
//
//   static Future<ObjectBoxService> create() async {
//     if (_instance != null) {
//       return _instance!;
//     } else {
//       final docsDir = await getApplicationDocumentsDirectory();
//       // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
//       final store =
//           await openStore(directory: p.join(docsDir.path, "hestatistics"));
//       _instance = ObjectBoxService._create(store);
//       return _instance!;
//     }
//   }
// }
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart';
import '../objects/db_local/db_local.dart';

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
      final storePath = p.join(docsDir.path, "hestatistics");

      // Check if the store is already open
      if (Store.isOpen(storePath)) {
        // Attach to the already opened store
        final store = Store.attach(getObjectBoxModel(),storePath);
        _instance = ObjectBoxService._create(store);
      } else {
        // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
        final store = await openStore(directory: storePath);
        _instance = ObjectBoxService._create(store);
      }
      return _instance!;
    }
  }
}
