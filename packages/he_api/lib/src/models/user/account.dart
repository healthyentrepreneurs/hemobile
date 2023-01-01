import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

/// {@template account}
/// {@contemplate}
@JsonSerializable()
class Account extends Equatable {
  /// {@macro account}
  const Account({this.id, this.username, this.email, this.lang, this.country});
  // ignore: public_member_api_docs
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
  final int? id;

  /// The current username.
  final String? username;

  /// The current user's email address.
  final String? email;

  /// The current user's lang.
  final String? lang;

  /// The current user's country.
  final String? country;

  /// Empty user which represents an unauthenticated user.
  static const empty = Account(id: 0);

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == Account.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != Account.empty;

  Account copyWith({
    int? id,
    String? username,
    String? email,
    String? lang,
    String? country,
  }) {
    return Account(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      lang: lang ?? this.lang,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [id, username, email, lang, country];

  static final toAccountOrNull = (Object? s) => s == null
      ? null
      : Account.fromJson(
          jsonDecode(s as String) as Map<String, dynamic>,
        );

  static final toAccountOrEmpty = (Object? s) => s == null
      ? Account.empty
      : Account.fromJson(
          jsonDecode(s as String) as Map<String, dynamic>,
        );

  static Future<Account?> toAccountOrNullFuture(Object? s) async => s == null
      ? null
      : Account.fromJson(jsonDecode(s as String) as Map<String, dynamic>);

  static String? accountToString(Account? u) =>
      u == null ? null : jsonEncode(u);

  static Future<String?> accountToStringFuture(Account? u) async =>
      u == null ? null : jsonEncode(u);
}
