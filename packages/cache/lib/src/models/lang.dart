import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lang.g.dart';

@JsonSerializable()
class Lang extends Equatable {
  const Lang({this.id, this.code = '', this.uppercode});
  final String code;
  final String? uppercode;
  final int? id;
  factory Lang.fromJson(Map<String, dynamic> json) => _$LangFromJson(json);
  static const empty = Lang();
  bool get isEmpty => this == Lang.empty;
  bool get isNotEmpty => this != Lang.empty;
  @override
  List<Object?> get props => [code, uppercode];
}
