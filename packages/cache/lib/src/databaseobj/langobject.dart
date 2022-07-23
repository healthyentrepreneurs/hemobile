import 'package:cache/cache.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Langobject extends Lang {
  @override
  int id = 0;
  late String code;
  late String uppercode;
  // static const Lang.empty
}
