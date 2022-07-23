// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return $checkedNew('User', json, () {
    final val = User(
      username: $checkedConvert(json, 'username', (v) => v as String),
      id: $checkedConvert(json, 'id', (v) => v as int?),
      token: $checkedConvert(json, 'token', (v) => v as String?),
      firstname: $checkedConvert(json, 'firstname', (v) => v as String?),
      lastname: $checkedConvert(json, 'lastname', (v) => v as String?),
      fullname: $checkedConvert(json, 'fullname', (v) => v as String?),
      email: $checkedConvert(json, 'email', (v) => v as String?),
      lang: $checkedConvert(json, 'lang', (v) => v as String?),
      country: $checkedConvert(json, 'country', (v) => v as String?),
      profileimageurlsmall:
          $checkedConvert(json, 'profileimageurlsmall', (v) => v as String?),
      profileimageurl:
          $checkedConvert(json, 'profileimageurl', (v) => v as String?),
      subscriptions: $checkedConvert(
          json,
          'subscriptions',
          (v) => (v as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : Subscription.fromJson(e as Map<String, dynamic>),)
              .toList(),),
    );
    return val;
  });
}
