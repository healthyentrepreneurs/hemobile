


// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Mycontent {
  Mycontent({
    required this.token,
    required this.privatetoken,
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.email,
    required this.department,
    required this.firstaccess,
    required this.lastaccess,
    required this.auth,
    required this.suspended,
    required this.confirmed,
    required this.lang,
    required this.theme,
    required this.timezone,
    required this.mailformat,
    required this.description,
    required this.descriptionformat,
    required this.country,
    required this.profileimageurlsmall,
    required this.profileimageurl,
    required this.subscriptions,
  });

  final String token;
  final dynamic privatetoken;
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String fullname;
  final String email;
  final String department;
  final int firstaccess;
  final int lastaccess;
  final String auth;
  final bool suspended;
  final bool confirmed;
  final String lang;
  final String theme;
  final String timezone;
  final int mailformat;
  final String description;
  final int descriptionformat;
  final String country;
  final String profileimageurlsmall;
  final String profileimageurl;
  final List<Subscription>? subscriptions;

  factory Mycontent.fromRawJson(String str) => Mycontent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mycontent.fromJson(Map<String, dynamic> json) => Mycontent(
    token: json["token"] == null ? null : json["token"],
    privatetoken: json["privatetoken"],
    id: json["id"] == null ? null : json["id"],
    username: json["username"] == null ? null : json["username"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    fullname: json["fullname"] == null ? null : json["fullname"],
    email: json["email"] == null ? null : json["email"],
    department: json["department"] == null ? null : json["department"],
    firstaccess: json["firstaccess"] == null ? null : json["firstaccess"],
    lastaccess: json["lastaccess"] == null ? null : json["lastaccess"],
    auth: json["auth"] == null ? null : json["auth"],
    suspended: json["suspended"] == null ? null : json["suspended"],
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    lang: json["lang"] == null ? null : json["lang"],
    theme: json["theme"] == null ? null : json["theme"],
    timezone: json["timezone"] == null ? null : json["timezone"],
    mailformat: json["mailformat"] == null ? null : json["mailformat"],
    description: json["description"] == null ? null : json["description"],
    descriptionformat: json["descriptionformat"] == null ? null : json["descriptionformat"],
    country: json["country"] == null ? null : json["country"],
    profileimageurlsmall: json["profileimageurlsmall"] == null ? null : json["profileimageurlsmall"],
    profileimageurl: json["profileimageurl"] == null ? null : json["profileimageurl"],
    subscriptions: json["subscriptions"] == null ? null : List<Subscription>.from(json["subscriptions"].map((x) => Subscription.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
    "privatetoken": privatetoken,
    "id": id == null ? null : id,
    "username": username == null ? null : username,
    "firstname": firstname == null ? null : firstname,
    "lastname": lastname == null ? null : lastname,
    "fullname": fullname == null ? null : fullname,
    "email": email == null ? null : email,
    "department": department == null ? null : department,
    "firstaccess": firstaccess == null ? null : firstaccess,
    "lastaccess": lastaccess == null ? null : lastaccess,
    "auth": auth == null ? null : auth,
    "suspended": suspended == null ? null : suspended,
    "confirmed": confirmed == null ? null : confirmed,
    "lang": lang == null ? null : lang,
    "theme": theme == null ? null : theme,
    "timezone": timezone == null ? null : timezone,
    "mailformat": mailformat == null ? null : mailformat,
    "description": description == null ? null : description,
    "descriptionformat": descriptionformat == null ? null : descriptionformat,
    "country": country == null ? null : country,
    "profileimageurlsmall": profileimageurlsmall == null ? null : profileimageurlsmall,
    "profileimageurl": profileimageurl == null ? null : profileimageurl,
    "subscriptions": subscriptions == null ? null : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
  };
}

class Subscription {
  Subscription({
    required this.id,
    required this.fullname,
    required this.categoryid,
    required this.source,
    required this.summaryCustome,
    required this.nextLink,
    required this.imageUrlSmall,
    required this.imageUrl,
  });

  final int id;
  final String fullname;
  final int categoryid;
  final String source;
  final String summaryCustome;
  final String nextLink;
  final String imageUrlSmall;
  final String imageUrl;

  factory Subscription.fromRawJson(String str) => Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["id"] == null ? null : json["id"],
    fullname: json["fullname"] == null ? null : json["fullname"],
    categoryid: json["categoryid"] == null ? null : json["categoryid"],
    source: json["source"] == null ? null : json["source"],
    summaryCustome: json["summary_custome"] == null ? null : json["summary_custome"],
    nextLink: json["next_link"] == null ? null : json["next_link"],
    imageUrlSmall: json["image_url_small"] == null ? null : json["image_url_small"],
    imageUrl: json["image_url"] == null ? null : json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "fullname": fullname == null ? null : fullname,
    "categoryid": categoryid == null ? null : categoryid,
    "source": source == null ? null : source,
    "summary_custome": summaryCustome == null ? null : summaryCustome,
    "next_link": nextLink == null ? null : nextLink,
    "image_url_small": imageUrlSmall == null ? null : imageUrlSmall,
    "image_url": imageUrl == null ? null : imageUrl,
  };
}
