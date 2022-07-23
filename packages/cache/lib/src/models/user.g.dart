// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return $checkedNew('User', json, () {
    final val = User(
      id: $checkedConvert(json, 'id', (v) => v as String?),
      email: $checkedConvert(json, 'email', (v) => v as String?),
      name: $checkedConvert(json, 'name', (v) => v as String?),
      username: $checkedConvert(json, 'username', (v) => v as String?),
      photo: $checkedConvert(json, 'photo', (v) => v as String?),
      token: $checkedConvert(json, 'token', (v) => v as String?),
      lang: $checkedConvert(json, 'lang', (v) => v as String?),
      country: $checkedConvert(json, 'country', (v) => v as String?),
      subscriptions: $checkedConvert(
          json,
          'subscriptions',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Subscription.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  });
}
