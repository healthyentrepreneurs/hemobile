


import 'package:json_annotation/json_annotation.dart';
import 'package:user_api/user_api.dart';

part 'user.g.dart';
/// {@template user}
/// User model
/// [User.empty] represents an unauthenticated user.
/// {@contemplate}
@JsonSerializable()
class User {
  /// {@macro user}
  const User({
    this.username='',
    this.id,
    this.token,
    this.firstname,
    this.lastname,
    this.fullname,
    this.email,
    this.lang,
    this.country,
    this.profileimageurlsmall,
    this.profileimageurl,
    this.subscriptions,
  });

  // ignore: public_member_api_docs
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  // factory User.fr
  /// The current user's id.
  final int? id;

  /// The current user's token.
  final String? token;

  /// The current user's username.
  final String username;

  /// The current user's firstname.
  final String? firstname;

  /// The current user's lastname.
  final String? lastname;

  /// The current user's fullname.
  final String? fullname;

  /// The current user's email address.
  final String? email;

  /// The current user's lang.
  final String? lang;

  /// The current user's country.
  final String? country;
  /// The current user's profileimageurlsmall.
  final String? profileimageurlsmall;

  /// The current user's profile
  final String? profileimageurl;

  /// The current user's content.
  final List<Subscription?>? subscriptions;

  /// Empty user which represents an unauthenticated user.
  static const empty = User();
  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;
  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;


}
