import 'dart:io';

import 'package:nl_health_app/db2/survey_nosql_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import '../../objectbox.g.dart';

// https://docs.objectbox.io/entity-annotations
// https://dev.to/theimpulson/persistent-local-database-with-objectbox-on-flutter-k5g
class HomeHelper {
  static Store? _store;
  // Start Survey
  Future<Tuple2<List<SurveyDataModel>, int>> getTotalCount() async {
    var store = await _getStore();
    var box = store.box<SurveyDataModel>();
    int totalData = box.count();
    List<SurveyDataModel> allSurveys = box.getAll();
    var t = Tuple2<List<SurveyDataModel>, int>(allSurveys, totalData);
    return t;
  }

  Future<int> saveSurveyLocal(SurveyDataModel surveyDataModel) async {
    var store = await _getStore();
    var box = store.box<SurveyDataModel>();
    return box.put(surveyDataModel);
    // return box.put(person);
  }

  Future<bool> deleteSurvey(int id) async {
    var store = await _getStore();
    var box = store.box<SurveyDataModel>();
    return box.remove(id);
  }
// End Survey

  //ViewsDataModel
  Future<Tuple2<List<ViewsDataModel>, int>> getTotalCountBooks() async {
    var store = await _getStore();
    var box = store.box<ViewsDataModel>();
    int totalData = box.count();
    List<ViewsDataModel> allBooks = box.getAll();
    var t = Tuple2<List<ViewsDataModel>, int>(allBooks, totalData);
    return t;
  }

  Future<int> saveBookLocal(ViewsDataModel bookDataModel) async {
    var store = await _getStore();
    var box = store.box<ViewsDataModel>();
    return box.put(bookDataModel);
    // return box.put(person);
  }

  Future<bool> deleteBookView(int id) async {
    var store = await _getStore();
    var box = store.box<ViewsDataModel>();
    return box.remove(id);
  }

  //End Of ViewBook
//objectBox Universal Methods
  Future<Store> _getStore() async {
    if (_store == null) {
      _store?.close();
      Directory dir = await getApplicationDocumentsDirectory();
      _store = Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
    }
    return _store!;
  }

  Future<void> closeDb() async {
    var store = await _getStore();
    store.close();
  }
}
