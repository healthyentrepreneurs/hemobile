part of 'database_bloc.dart';

const emptySub = <Subscription>[];

@immutable
class DatabaseState extends Equatable {
  const DatabaseState._(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? displayName,
      this.error})
      : _displayName = displayName ?? '',
        _listOfSubscriptionData = listOfSubscriptionData ?? emptySub,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final List<Subscription?> _listOfSubscriptionData;
  final String _displayName;
  final HenetworkStatus _henetworkStatus;
  final Failure? error;
  const DatabaseState.loading(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? displayName})
      : this._(
            listOfSubscriptionData: listOfSubscriptionData ?? emptySub,
            henetworkStatus: henetworkStatus,
            displayName: displayName);

  DatabaseState copyWith(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? displayName,
      Failure? error}) {
    return DatabaseState._(
        listOfSubscriptionData:
            listOfSubscriptionData ?? _listOfSubscriptionData,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        displayName: displayName ?? _displayName,
        error: error ?? this.error);
  }

  //create a getter for the list of subscription data
  List<Subscription?> get glistOfSubscriptionData => _listOfSubscriptionData;
  HenetworkStatus get ghenetworkStatus => _henetworkStatus;
  String get gdisplayName => _displayName;

  // create toJson and fromJson methods
  Map<String, dynamic> toJson() => {
        'listOfSubscriptionData': _listOfSubscriptionData,
        'henetworkStatus': _henetworkStatus.name,
        'displayName': _displayName,
        'error': error,
      };
  // fromJson method
  factory DatabaseState.fromJson(Map<String, dynamic> json) {
    final subscriptions = List<Subscription?>.from(
        json['listOfSubscriptionData']
            .map((data) => Subscription.fromJson(data)));

    final String henetworkStatusString = json['henetworkStatus'];
    HenetworkStatus henetworkStatus;
    if (henetworkStatusString != null) {
      henetworkStatus = HenetworkStatus.values.firstWhere(
        (status) => status.name == henetworkStatusString,
        orElse: () => HenetworkStatus.loading,
      );
    } else {
      henetworkStatus = HenetworkStatus.loading;
    }

    return DatabaseState._(
        listOfSubscriptionData: subscriptions,
        henetworkStatus: henetworkStatus,
        displayName: json['displayName'],
        error: json['error']);
  }
  @override
  List<Object?> get props =>
      [glistOfSubscriptionData, gdisplayName, ghenetworkStatus, error];
}
