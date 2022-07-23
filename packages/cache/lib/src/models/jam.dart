import 'package:json_annotation/json_annotation.dart';

part 'jam.g.dart';

@JsonSerializable(explicitToJson: true)
class Jam {
  Jam(this.name, this.email);

  String name;
  String email;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Jam.fromJson(Map<String, dynamic> json) => _$JamFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  // Map<String, dynamic> toJson() => _$JamToJson(this);
}
