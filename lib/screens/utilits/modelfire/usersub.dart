// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Mycontent {
    Mycontent({
        this.Token,
        this.Privatetoken,
        this.ID,
        this.Username,
        this.Firstname,
        this.Lastname,
        this.Fullname,
        this.Email,
        this.Department,
        this.Firstaccess,
        this.Lastaccess,
        this.Auth,
        this.Suspended,
        this.Confirmed,
        this.Lang,
        this.Theme,
        this.Timezone,
        this.Mailformat,
        this.Description,
        this.Descriptionformat,
        this.Country,
        this.Profileimageurlsmall,
        this.Profileimageurl,
        this.Subscriptions,
    });

    final String? Token;
    final dynamic Privatetoken;
    final int? ID;
    final String? Username;
    final String? Firstname;
    final String? Lastname;
    final String? Fullname;
    final String? Email;
    final String? Department;
    final int? Firstaccess;
    final int? Lastaccess;
    final String? Auth;
    final bool? Suspended;
    final bool? Confirmed;
    final String? Lang;
    final String? Theme;
    final String? Timezone;
    final int? Mailformat;
    final String? Description;
    final int? Descriptionformat;
    final String? Country;
    final String? Profileimageurlsmall;
    final String? Profileimageurl;
    final List<Subscription>? Subscriptions;

    factory Mycontent.fromRawJson(String str) => Mycontent.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Mycontent.fromJson(Map<String, dynamic> json) => Mycontent(
        Token: json["Token"] == null ? null : json["Token"],
        Privatetoken: json["Privatetoken"],
        ID: json["ID"] == null ? null : json["ID"],
        Username: json["Username"] == null ? null : json["Username"],
        Firstname: json["Firstname"] == null ? null : json["Firstname"],
        Lastname: json["Lastname"] == null ? null : json["Lastname"],
        Fullname: json["Fullname"] == null ? null : json["Fullname"],
        Email: json["Email"] == null ? null : json["Email"],
        Department: json["Department"] == null ? null : json["Department"],
        Firstaccess: json["Firstaccess"] == null ? null : json["Firstaccess"],
        Lastaccess: json["Lastaccess"] == null ? null : json["Lastaccess"],
        Auth: json["Auth"] == null ? null : json["Auth"],
        Suspended: json["Suspended"] == null ? null : json["Suspended"],
        Confirmed: json["Confirmed"] == null ? null : json["Confirmed"],
        Lang: json["Lang"] == null ? null : json["Lang"],
        Theme: json["Theme"] == null ? null : json["Theme"],
        Timezone: json["Timezone"] == null ? null : json["Timezone"],
        Mailformat: json["Mailformat"] == null ? null : json["Mailformat"],
        Description: json["Description"] == null ? null : json["Description"],
        Descriptionformat: json["Descriptionformat"] == null ? null : json["Descriptionformat"],
        Country: json["Country"] == null ? null : json["Country"],
        Profileimageurlsmall: json["Profileimageurlsmall"] == null ? null : json["Profileimageurlsmall"],
        Profileimageurl: json["Profileimageurl"] == null ? null : json["Profileimageurl"],
        Subscriptions: json["Subscriptions"] == null ? null : List<Subscription>.from(json["Subscriptions"].map((x) => Subscription.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Token": Token == null ? null : Token,
        "Privatetoken": Privatetoken,
        "ID": ID == null ? null : ID,
        "Username": Username == null ? null : Username,
        "Firstname": Firstname == null ? null : Firstname,
        "Lastname": Lastname == null ? null : Lastname,
        "Fullname": Fullname == null ? null : Fullname,
        "Email": Email == null ? null : Email,
        "Department": Department == null ? null : Department,
        "Firstaccess": Firstaccess == null ? null : Firstaccess,
        "Lastaccess": Lastaccess == null ? null : Lastaccess,
        "Auth": Auth == null ? null : Auth,
        "Suspended": Suspended == null ? null : Suspended,
        "Confirmed": Confirmed == null ? null : Confirmed,
        "Lang": Lang == null ? null : Lang,
        "Theme": Theme == null ? null : Theme,
        "Timezone": Timezone == null ? null : Timezone,
        "Mailformat": Mailformat == null ? null : Mailformat,
        "Description": Description == null ? null : Description,
        "Descriptionformat": Descriptionformat == null ? null : Descriptionformat,
        "Country": Country == null ? null : Country,
        "Profileimageurlsmall": Profileimageurlsmall == null ? null : Profileimageurlsmall,
        "Profileimageurl": Profileimageurl == null ? null : Profileimageurl,
        "Subscriptions": Subscriptions == null ? null : List<dynamic>.from(Subscriptions!.map((x) => x.toJson())),
    };
}

class Subscription {
    Subscription({
        required this.ID,
         this.Fullname,
         this.CategoryID,
         this.Source,
         this.SummaryCustome,
         this.NextLink,
         this.ImageURLSmall,
         this.ImageURL,
    });

    final int ID;
    final String? Fullname;
    final int? CategoryID;
    final String? Source;
    final String? SummaryCustome;
    final String? NextLink;
    final String? ImageURLSmall;
    final String? ImageURL;

    factory Subscription.fromRawJson(String str) => Subscription.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        ID: json["ID"] == null ? null : json["ID"],
        Fullname: json["Fullname"] == null ? null : json["Fullname"],
        CategoryID: json["CategoryID"] == null ? null : json["CategoryID"],
        Source: json["Source"] == null ? null : json["Source"],
        SummaryCustome: json["SummaryCustome"] == null ? null : json["SummaryCustome"],
        NextLink: json["NextLink"] == null ? null : json["NextLink"],
        ImageURLSmall: json["ImageURLSmall"] == null ? null : json["ImageURLSmall"],
        ImageURL: json["ImageURL"] == null ? null : json["ImageURL"],
    );

    Map<String, dynamic> toJson() => {
        "ID": ID == null ? null : ID,
        "Fullname": Fullname == null ? null : Fullname,
        "CategoryID": CategoryID == null ? null : CategoryID,
        "Source": Source == null ? null : Source,
        "SummaryCustome": SummaryCustome == null ? null : SummaryCustome,
        "NextLink": NextLink == null ? null : NextLink,
        "ImageURLSmall": ImageURLSmall == null ? null : ImageURLSmall,
        "ImageURL": ImageURL == null ? null : ImageURL,
    };
}
