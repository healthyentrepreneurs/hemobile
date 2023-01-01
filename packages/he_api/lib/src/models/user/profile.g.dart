// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      lang: json['lang'] as String?,
      country: json['country'] as String?,
      token: json['token'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      profileimageurlsmall: json['profileimageurlsmall'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'lang': instance.lang,
      'country': instance.country,
      'token': instance.token,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'profileimageurlsmall': instance.profileimageurlsmall,
    };
