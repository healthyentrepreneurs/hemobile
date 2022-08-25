import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

/// {@printOnlyDebug} Print Only in debug mode

void printOnlyDebug(Object objectPrint) {
  if (isInDebugMode) {
    // ignore: avoid_print
    print(objectPrint);
  }
}

// ignore: public_member_api_docs
bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true, 'a must not be in production');
  return inDebugMode;
}

///Base Url for user api
// const baseUrl = '192.168.0.26:5051';
// const baseUrl = '192.168.0.26:5051';
const baseUrl = 'https://a783-154-76-38-26.ngrok.io';

///Url for login
const userLoginUrl = '$baseUrl/login';

/// Call by https
const bool secured = true;

///Custome made https/http calls for making multiple requests to the same server,
Future<Response> httpP(
  Client client,
  String baseUrl,
  String pathQuery,
  Map<String, dynamic> parameters,
  String type,
) async {
  // Uri request;
  // if (secured) {
  //   // request = Uri.https(
  //   //   baseUrl,
  //   //   pathQuery,
  //   //   parameters,
  //   // );
  //    request = await http(
  //       Uri.parse(baseUrl+pathQuery),
  //       body: parameters,
  //   );
  // } else {
  //   request = Uri.http(
  //     baseUrl,
  //     pathQuery,
  //     parameters,
  //   );
  // }
  // return type == 'get' ? client.get(request) : client.post(request);

  // final request = http.post(
  //   Uri.parse(baseUrl + pathQuery),
  //   body: parameters,
  // );
  Response request;
  final uri = Uri.parse(baseUrl + pathQuery);
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = parameters;
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  request = await http.post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );
  int statusCode = request.statusCode;
  return request;
}

///Custome made https/http calls direct urls
Future<Response> httpPDirect(
  Client client,
  String baseUrl,
  Map<String, String> parameters,
  String type,
) async {
  final request = Uri.parse(baseUrl);
  return type == 'get'
      ? client.post(request, body: parameters)
      : client.post(request, body: parameters);
}
