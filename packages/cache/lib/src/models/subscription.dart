import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

/// {@template subscription}
/// [Subscription.empty] represents user without content.
/// {@contemplate}
@JsonSerializable()
class Subscription extends Equatable {
  /// {@macro subscription}
  const Subscription({
    this.id,
    this.fullname,
    this.source,
    this.summaryCustome,
    this.imageUrlSmall,
  });
  // ignore: public_member_api_docs
  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  /// The current user's id.
  final int? id;

  /// The current user's fullname.
  final String? fullname;

  /// The current user's source.
  final String? source;

  /// The current user's summaryCustom.
  final String? summaryCustome;

  /// The current user's nextLink.

  /// The current user's imageUrlSmall.
  final String? imageUrlSmall;

  /// Empty user which represents an  user. with no content
  static const empty = Subscription();

  /// Convenience getter to determine if  user has zero subscriptions.
  bool get isEmpty => this == Subscription.empty;

  ///getter is user has subscriptions.
  bool get isNotEmpty => this != Subscription.empty;

  @override
  List<Object?> get props =>
      [id, fullname, source, summaryCustome, imageUrlSmall];
}