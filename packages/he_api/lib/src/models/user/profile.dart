import 'package:he_api/he_api.dart';
import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

/*{@template profile}
 {@contemplate}*/
@JsonSerializable()
class Profile extends Account {
  /// {@macro profile}
  const Profile({
    super.id,
    super.username,
    super.email,
    super.lang,
    super.country,
    this.token,
    this.firstname,
    this.lastname,
    this.profileimageurlsmall,
  });

  // ignore: public_member_api_docs
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  /// {@macro profile}
  final String? token;

  /// The current username.
  final String? firstname;

  /// The current user's email address.
  final String? lastname;

  /// The current user's lang.
  final String? profileimageurlsmall;

  String get fullName => '$firstname $lastname';

  @override
  Profile copyWith({
    int? id,
    String? username,
    String? email,
    String? lang,
    String? country,
    String? token,
    String? firstname,
    String? lastname,
    String? profileimageurlsmall,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      lang: lang ?? this.lang,
      country: country ?? this.country,
      token: token ?? this.token,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      profileimageurlsmall: profileimageurlsmall ?? this.profileimageurlsmall,
    );
  }

  @override
  List<Object?> get props => [
        super.id,
        super.username,
        super.email,
        super.lang,
        super.country,
        token,
        firstname,
        lastname,
        profileimageurlsmall
      ];
}
