import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  int id;
  String firstName;
  String lastName;

  Person({required this.id, required this.firstName, required this.lastName});
}