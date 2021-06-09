

import 'package:nl_health_app/db2/survey_nosql_model.dart';
import '../objectbox.g.dart';

final store = Store(getObjectBoxModel());
final box = store.box<SurveyDataModel>();

var person = SurveyDataModel()
  ..text = "Joe"
  ..name = "Green";

final id = box.put(person);  // Create
//person = box.get(id);        // Read
//person. = "Black";
//box.put(person);             // Update
//box.remove(person.id);       // Delete

// find all people whose name start with letter 'J'
//final query = box.query(Person_.firstName.startsWith('J')).build();
//final people = query.find();  // find() returns List<Person>
