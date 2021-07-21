

import 'package:http/http.dart' as http;
import 'package:nl_health_app/screens/utilits/models/user_model.dart';
import 'package:nl_health_app/screens/utilits/toolsUtilits.dart';
import 'dart:convert';

class OpenApi {
  Uri urlConvert(String url){
    return Uri.parse(url);
  }
  Future<http.Response> login(String email, String password) {
    return http.post(urlConvert(Config.BASE_URL+ 'login'),
        body: {'username': email, 'password': password});
  }

  Future<http.Response> register(
      String email, String firstName, String lastName) {
    return http.post(urlConvert(Config.BASE_URL + 'user/set_newuser'),
        body: {'email': email, 'firstname': firstName, 'lastname': lastName});
  }

  Future<http.Response> postSurveyJsonData(String body, int userId) {
    //http://35.238.72.107/user/get_moodle_courses
    //https://helper.healthyentrepreneurs.nl/survey/saveobject_surv
    return http.post(urlConvert(Config.BASE_URL + 'survey/saveobject_surv'),
        headers: {"Content-Type": "application/json"},
        body: body);
  }

  Future<http.Response> imageBytePost(List<int>  body,String imageName ,String userId,String surveyId) async{
    var request = http.MultipartRequest('POST', Uri.parse(Config.BASE_URL + 'surveyimage/do_upload'));
    request.files.add(
        http.MultipartFile.fromBytes(
            'userfile',
            body,
            filename: imageName
        )
    );
    request.fields['user_id'] = userId;
    request.fields['survey_id'] = surveyId;
    var res = await request.send();
    return await http.Response.fromStream(res);
    // return request.send();
  }
  Future<http.Response> listCourses() {
    //http://35.238.72.107/user/get_moodle_courses
    return http.post(urlConvert(Config.BASE_URL + 'user/get_moodle_courses'));
  }

  Future<http.Response> listCoursesWithToken(String token, int userId) {
    //http://35.238.72.107/user/get_moodle_courses
    print(Config.BASE_URL + 'user/get_moodle_courses/$token/$userId');
    return http
        .post(urlConvert(Config.BASE_URL + 'user/get_moodle_courses/$token/$userId'));
  }

  Future<http.Response> listQuizItems(dynamic id, String token,
      [int page = 0]) {
    //http://35.238.72.107/user/get_moodle_courses
    //https://helper.healthyentrepreneurs.nl/quiz/get_quiz_em/3/0/de81bb4eb4e8303a15b00a5c61554e2a
    return http.post(urlConvert(Config.BASE_URL + 'quiz/get_quiz_em/3/$page/$token'));
    //return http.post('https://helper.healthyentrepreneurs.nl/quiz/get_quiz_em/3/0/de81bb4eb4e8303a15b00a5c61554e2a');
  }

  Future<http.Response> listSubCourses(String nextLink) {
    //http://35.238.72.107/user/get_details_percourse/1
    return http.post(urlConvert(nextLink));
  }

  Future<User?> fetchAlbum(String email, String password) async {
    final response = await login(email, password);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var json = jsonDecode(response.body);
      print(json['code']);
      if (json['code'] == 200) {
        return User.fromJson(json['data']);
      } else {
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<http.Response> readHtmlTxt(String url) {
    return http.post(urlConvert(url));
  }

  Future<http.Response> postStats(String token, dynamic bookId, dynamic chapterId, dynamic username, dynamic courseId,dynamic dateTime,) {
    //user/viwedbook/{instanceid}/{path}/{token}/{username}
    //print(Config.BASE_URL + 'user/viwedbook/$bookId/$chapterId/$token/$username/$courseId?dateTime=$dateTime');
    return http.post(urlConvert(Config.BASE_URL + 'user/viwedbook/$bookId/$chapterId/$token/$username/$courseId?dateTime=$dateTime'));
  }


}
