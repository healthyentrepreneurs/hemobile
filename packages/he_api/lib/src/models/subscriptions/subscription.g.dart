// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as int?,
      fullname: json['fullname'] as String?,
      source: json['source'] as String?,
      summaryCustome: json['summary_custome'] as String?,
      categoryid: json['categoryid'] as int?,
      imageUrl: json['image_url'] as String?,
      imageUrlSmall: json['image_url_small'] as String?,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'source': instance.source,
      'summary_custome': instance.summaryCustome,
      'categoryid': instance.categoryid,
      'image_url': instance.imageUrl,
      'image_url_small': instance.imageUrlSmall,
    };
