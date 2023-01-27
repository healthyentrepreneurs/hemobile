// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      lang: json['lang'] as String?,
      country: json['country'] as String?,
      token: json['token'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      profileimageurlsmall: json['profileimageurlsmall'] as String?,
      subscriptions: (json['subscriptions'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : Subscription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'lang': instance.lang,
      'country': instance.country,
      'token': instance.token,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'profileimageurlsmall': instance.profileimageurlsmall,
      'subscriptions': instance.subscriptions?.map((e) => e?.toJson()).toList(),
    };
