import 'package:equatable/equatable.dart';
import 'package:he_api/he_api.dart';
import 'package:json_annotation/json_annotation.dart';
part 'datacode.g.dart';


/// {@template user}
/// {@contemplate}
@JsonSerializable()
class DataCode extends Equatable {
  /// {@macro user}
  const DataCode({
    this.code,
    this.msg,
    this.data,
  });

  // ignore: public_member_api_docs
  factory DataCode.fromJson(Map<String, dynamic> json) =>
      _$DataCodeFromJson(json);
  Map<String, dynamic> toJson() => _$DataCodeToJson(this);

  /// The current user's code.
  final int? code;

  /// The msg
  final String? msg;

  /// The user data
  final User? data;

  /// Empty user which represents an unauthenticated user.
  static const empty = DataCode();

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == DataCode.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != DataCode.empty;

  @override
  List<Object?> get props => [
        code,
        msg,
        data,
      ];
}
