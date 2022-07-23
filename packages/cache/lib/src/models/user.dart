import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// User model
/// [User.empty] represents an unauthenticated user.
/// {@contemplate}
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  // ignore_for_file: public_member_api_docs
  const User({
    this.id,
    this.email,
    this.name,
    this.username = '',
    this.photo,
    this.token,
    this.lang,
    this.country,
    this.subscriptions,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  final String? email;

  final String? id;

  final String? name;

  final String? photo;

  final String? username;

  final String? token;

  final String? lang;

  final String? country;

  final List<Subscription>? subscriptions;

  static const empty = User();

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo, username];
}
