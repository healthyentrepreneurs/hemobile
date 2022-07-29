import 'package:http/http.dart';

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
const baseUrl = 'http://stagingapp.healthyentrepreneurs.nl';

///Url for login
const userLoginUrl = '$baseUrl/userlogin';

/// Call by https
const bool secured = false;

///Custome made https/http calls for making multiple requests to the same server,
Future<Response> httpP(
  Client client,
  String baseUrl,
  String pathQuery,
  Map<String, String> parameters,
  String type,
) async {
  Uri request;
  if (secured) {
    request = Uri.https(
      baseUrl,
      pathQuery,
      parameters,
    );
  } else {
    request = Uri.http(
      baseUrl,
      pathQuery,
      parameters,
    );
  }
  return type == 'get' ? client.get(request) : client.post(request);
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
