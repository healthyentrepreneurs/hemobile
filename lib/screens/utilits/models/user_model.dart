import 'dart:convert';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String? password;
  String profileImage;
  String token;
  String privatetoken;
  String username;

  User({ required this.id,required this.firstName, required this.lastName, required this.email, required this.profileImage,
    required this.token,required this.privatetoken,required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      profileImage: json['profileimageurlsmall'],
      token: json['token'],
      privatetoken: json['privatetoken'],
      username: json['username'],
    );
  }


}
