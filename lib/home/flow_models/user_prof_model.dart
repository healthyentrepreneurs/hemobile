import 'package:equatable/equatable.dart';
import 'package:he/helper/file_system_util.dart';
import 'package:he_api/he_api.dart';

class UserProfileModel extends Equatable {
  const UserProfileModel({this.henetworkStatus,this.subscriptionList, this.subscription});

  final HenetworkStatus? henetworkStatus;
  final Subscription? subscription;
  final List<Subscription?>?  subscriptionList;
  UserProfileModel copyWith(
      {HenetworkStatus? henetworkStatus,List<Subscription?>?  subscriptionList, Subscription? subscription}) {
    return UserProfileModel(
      henetworkStatus: henetworkStatus ?? this.henetworkStatus,
      subscriptionList: subscriptionList ?? this.subscriptionList,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props => [henetworkStatus, subscription,subscriptionList];
}
