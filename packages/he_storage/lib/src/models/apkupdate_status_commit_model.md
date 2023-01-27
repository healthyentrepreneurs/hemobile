import 'package:he_storage/he_storage.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ApkupdateStatusCommit extends Apkupdatestatus {
  @Id()
  int id;

  @override
  String seen = "";

  @override
  String updated = "";

  ApkupdateStatusCommit(
      {required super.seen, required super.updated, this.id = 0});
}
