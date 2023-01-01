import 'package:he_api/he_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

/// {@template user}
@immutable
@JsonSerializable()
class User extends Profile {
  /// {@macro user}
  const User({
    super.id,
    super.username,
    super.email,
    super.lang,
    super.country,
    super.token,
    super.firstname,
    super.lastname,
    super.profileimageurlsmall,
    this.subscriptions,
  });
  // ignore: public_member_api_docs
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// The current user's content.
  final List<Subscription?>? subscriptions;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: 0);

  /// Convenience getter to determine whether the current user is empty.
  @override
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  @override
  bool get isNotEmpty => super != User.empty;

  @override
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? lang,
    String? country,
    String? token,
    String? firstname,
    String? lastname,
    String? profileimageurlsmall,
    List<Subscription?>? subscriptions,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      lang: lang ?? this.lang,
      country: country ?? this.country,
      token: token ?? this.token,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      profileimageurlsmall: profileimageurlsmall ?? this.profileimageurlsmall,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        firstname,
        lastname,
        email,
        lang,
        country,
        profileimageurlsmall
      ];
}
