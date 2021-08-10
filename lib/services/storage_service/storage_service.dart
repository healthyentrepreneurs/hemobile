import 'package:nl_health_app/screens/utilits/models/user_model.dart';

abstract class StorageService {
  Future<User?> getUser();
  Future<void> setUser(User userToSave);
  Future<int?> getLogin();
  Future<String?> getSurveyUploadDate();
  Future<void> setLogin(int value);
  Future<String> getOnline();
  Future<void> setOnline(String value);
  Future<void> setOffline(String value);
  Future<void> setSurveyUploadDate(String value);
  Future<void> clearLogin();
}
