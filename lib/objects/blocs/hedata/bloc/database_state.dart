part of 'database_bloc.dart';

const emptySub = <Subscription>[];

@immutable
class DatabaseState extends Equatable {
  const DatabaseState._(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? userid,
      Subscription? selectedsubscription,
      this.error,
      this.fetchError,
      this.surveyTotalCount})
      : _userid = userid ?? '',
        _selectedsubscription = selectedsubscription,
        _listOfSubscriptionData = listOfSubscriptionData ?? emptySub,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final List<Subscription?> _listOfSubscriptionData;
  final String _userid;
  final HenetworkStatus _henetworkStatus;
  final Failure? error;
  final Failure? fetchError;
  final Subscription? _selectedsubscription;
  final int? surveyTotalCount;

  const DatabaseState.loading(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? userid})
      : this._(
            listOfSubscriptionData: listOfSubscriptionData ?? emptySub,
            henetworkStatus: henetworkStatus,
            userid: userid);

  DatabaseState copyWith(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      Subscription? selectedsubscription,
      String? userid,
      Failure? error,
      Failure? fetchError,
      int? surveyTotalCount}) {
    return DatabaseState._(
        listOfSubscriptionData:
            listOfSubscriptionData ?? _listOfSubscriptionData,
        selectedsubscription: selectedsubscription ?? _selectedsubscription,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        userid: userid ?? _userid,
        error: error ?? this.error,
        fetchError: fetchError ?? this.fetchError,
        surveyTotalCount: surveyTotalCount ?? this.surveyTotalCount);
  }

  const DatabaseState.withError(
      {HenetworkStatus? henetworkStatus, Failure? error})
      : this._(
          listOfSubscriptionData: emptySub,
          henetworkStatus: henetworkStatus,
          error: error,
        );

  //create a getter for the list of subscription data
  List<Subscription?> get glistOfSubscriptionData => _listOfSubscriptionData;
  HenetworkStatus get ghenetworkStatus => _henetworkStatus;
  String get guserid => _userid;
  Subscription? get gselectedsubscription => _selectedsubscription;

  @override
  List<Object?> get props => [
        glistOfSubscriptionData,
        guserid,
        ghenetworkStatus,
        gselectedsubscription,
        error,
        fetchError,
        surveyTotalCount
      ];
}
