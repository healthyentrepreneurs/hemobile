import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

@JsonSerializable()
class Section extends Equatable{
  Section({
    required this.id,
    this.name,
    this.section,
    this.uservisible,
  });
  int id;
  String? name;
  int? section;
  bool? uservisible;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);

  @override
  List<Object?> get props => [id,name,section,uservisible];
}