class User {
  User({
    required this.token,
    this.privatetoken,
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fullname,
    required this.email,
    this.department,
    this.firstaccess,
    this.lastaccess,
    this.auth,
    this.suspended,
    this.confirmed,
    this.lang,
    this.theme,
    this.timezone,
    this.mailformat,
    this.description,
    this.descriptionformat,
    this.country,
    required this.profileimageurlsmall,
    this.profileimageurl,
  });

  final String token;
  final String? privatetoken;
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String fullname;
  final String email;
  final String? department;
  final int? firstaccess;
  final int? lastaccess;
  final String? auth;
  final bool? suspended;
  final bool? confirmed;
  final String? lang;
  final String? theme;
  final String? timezone;
  final int? mailformat;
  final String? description;
  final int? descriptionformat;
  final String? country;
  final String? profileimageurlsmall;
  final String? profileimageurl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"] == null ? null : json["token"],
        privatetoken: json["privatetoken"] == null ? null : json["privatetoken"],
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
        descriptionformat: json["descriptionformat"] == null
            ? null
            : json["descriptionformat"],
        country: json["country"] == null ? null : json["country"],
        profileimageurlsmall: json["profileimageurlsmall"] == null
            ? null
            : json["profileimageurlsmall"],
        profileimageurl:
            json["profileimageurl"] == null ? null : json["profileimageurl"],
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
        "descriptionformat":
            descriptionformat == null ? null : descriptionformat,
        "country": country == null ? null : country,
        "profileimageurlsmall":
            profileimageurlsmall == null ? null : profileimageurlsmall,
        "profileimageurl": profileimageurl == null ? null : profileimageurl,
      };
}
