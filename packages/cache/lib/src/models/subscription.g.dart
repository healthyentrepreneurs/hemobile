// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Subscription',
      json,
      ($checkedConvert) {
        final val = Subscription(
          id: $checkedConvert('id', (v) => v as int?),
          fullname: $checkedConvert('fullname', (v) => v as String?),
          source: $checkedConvert('source', (v) => v as String?),
          summaryCustome:
              $checkedConvert('summary_custome', (v) => v as String?),
          imageUrlSmall:
              $checkedConvert('image_url_small', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'summaryCustome': 'summary_custome',
        'imageUrlSmall': 'image_url_small'
      },
    );
