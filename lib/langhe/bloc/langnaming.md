Future<List<Lang>> _fetchLanguages([int startIndex = 0]) async {
String languages = """{
"languages":  [
{
"code": "en",
"name": "English",
"country": "US"
},
{
"code": "es",
"name": "Luganda",
"country": "UGANDA"
},
{
"code": "de",
"name": "Runyankole",
"country": "UGANDA"
},
{
"code": "nn",
"name": "Wanga",
"country": "UGANDA"
}
]}
""";
final body = json.decode(languages)['languages'] as List;
return body.map((dynamic json) {
return Lang(
code: json['code'] as String,
name: json['name'] as String,
country: json['country'] as String,
);
}).toList();
}