import 'package:cache/cache.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Userobject extends User {
  @Id()
  int userid = 0;
  late String email;
}
