// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return $checkedNew('Subscription', json, () {
    final val = Subscription(
      id: $checkedConvert(json, 'id', (v) => v as int?),
      fullname: $checkedConvert(json, 'fullname', (v) => v as String?),
      source: $checkedConvert(json, 'source', (v) => v as String?),
      summaryCustome:
          $checkedConvert(json, 'summary_custome', (v) => v as String?),
      imageUrlSmall:
          $checkedConvert(json, 'image_url_small', (v) => v as String?),
    );
    return val;
  }, fieldKeyMap: const {
    'summaryCustome': 'summary_custome',
    'imageUrlSmall': 'image_url_small'
  });
}
