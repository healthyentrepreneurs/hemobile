// objectuser
import 'objectsubscription.dart';

class ObjectUser {
  ObjectUser({
    this.token,
    required this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.fullname,
    this.email,
    this.lang,
    this.country,
    this.profileimageurlsmall,
    this.profileimageurl,
    required this.subscriptions,
  });

  String? token;
  int id;
  String? username;
  String? firstname;
  String? lastname;
  String? fullname;
  String? email;
  String? lang;
  String? country;
  String? profileimageurlsmall;
  String? profileimageurl;
  List<ObjectSubscription> subscriptions;

  factory ObjectUser.fromJson(Map<String, dynamic> json) => ObjectUser(
        token: json["token"],
        id: json["id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        fullname: json["fullname"],
        email: json["email"],
        lang: json["lang"],
        country: json["country"],
        profileimageurlsmall: json["profileimageurlsmall"],
        profileimageurl: json["profileimageurl"],
        subscriptions: List<ObjectSubscription>.from(
            json["subscriptions"].map((x) => ObjectSubscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "fullname": fullname,
        "email": email,
        "lang": lang,
        "country": country,
        "profileimageurlsmall": profileimageurlsmall,
        "profileimageurl": profileimageurl,
        "subscriptions":
            List<dynamic>.from(subscriptions.map((x) => x.toJson())),
      };
}
