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
          id: $checkedConvert('id', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String?),
          name: $checkedConvert('name', (v) => v as String?),
          username: $checkedConvert('username', (v) => v as String? ?? ''),
          photo: $checkedConvert('photo', (v) => v as String?),
          token: $checkedConvert('token', (v) => v as String?),
          lang: $checkedConvert('lang', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
          subscriptions: $checkedConvert(
              'subscriptions',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => Subscription.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );
