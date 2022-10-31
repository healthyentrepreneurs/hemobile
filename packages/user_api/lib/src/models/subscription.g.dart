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
          categoryid: $checkedConvert('categoryid', (v) => v as int?),
          source: $checkedConvert('source', (v) => v as String?),
          summaryCustome:
              $checkedConvert('summary_custome', (v) => v as String?),
          nextLink: $checkedConvert('next_link', (v) => v as String?),
          imageUrlSmall:
              $checkedConvert('image_url_small', (v) => v as String?),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'summaryCustome': 'summary_custome',
        'nextLink': 'next_link',
        'imageUrlSmall': 'image_url_small',
        'imageUrl': 'image_url'
      },
    );
