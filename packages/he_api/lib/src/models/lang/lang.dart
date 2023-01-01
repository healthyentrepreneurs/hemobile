import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lang.g.dart';
@JsonSerializable()
class Lang extends Equatable {
  const Lang({this.code='', this.name,this.country});
  final String code;
  final String? name;
  final String? country;
  factory Lang.fromJson(Map<String, dynamic> json) => _$LangFromJson(json);
  static const empty = Lang();
  bool get isEmpty => this == Lang.empty;
  bool get isNotEmpty => this != Lang.empty;
  @override
  List<Object?> get props => [code, name, country];
}