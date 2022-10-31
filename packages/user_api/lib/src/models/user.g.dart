// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          username: $checkedConvert('username', (v) => v as String? ?? ''),
          id: $checkedConvert('id', (v) => v as int?),
          token: $checkedConvert('token', (v) => v as String?),
          firstname: $checkedConvert('firstname', (v) => v as String?),
          lastname: $checkedConvert('lastname', (v) => v as String?),
          fullname: $checkedConvert('fullname', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          lang: $checkedConvert('lang', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
          profileimageurlsmall:
              $checkedConvert('profileimageurlsmall', (v) => v as String?),
          profileimageurl:
              $checkedConvert('profileimageurl', (v) => v as String?),
          subscriptions: $checkedConvert(
              'subscriptions',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => e == null
                      ? null
                      : Subscription.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );
