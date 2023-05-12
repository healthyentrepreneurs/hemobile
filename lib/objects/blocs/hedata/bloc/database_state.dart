part of 'database_bloc.dart';

const emptySubList = <Subscription>[];
// const emptySurveyDataList = <SurveyDataModel>[];

@immutable
class DatabaseState extends Equatable {
  const DatabaseState._({
    List<Subscription?>? listOfSubscriptionData,
    HenetworkStatus? henetworkStatus,
    String? userid,
    Subscription? selectedsubscription,
    this.error,
  })  : _userid = userid ?? '',
        _selectedsubscription = selectedsubscription,
        _listOfSubscriptionData = listOfSubscriptionData ?? emptySubList,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final List<Subscription?> _listOfSubscriptionData;
  final String _userid;
  final HenetworkStatus _henetworkStatus;
  final Failure? error;
  final Subscription? _selectedsubscription;
  // final int? surveyTotalCount;
  //Uploading End

  const DatabaseState.loading(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      String? userid})
      : this._(
            listOfSubscriptionData: listOfSubscriptionData ?? emptySubList,
            henetworkStatus: henetworkStatus,
            userid: userid);

  DatabaseState copyWith(
      {List<Subscription?>? listOfSubscriptionData,
      HenetworkStatus? henetworkStatus,
      Subscription? selectedsubscription,
      String? userid,
      Failure? error,
      Failure? fetchError}) {
    return DatabaseState._(
      listOfSubscriptionData: listOfSubscriptionData ?? _listOfSubscriptionData,
      selectedsubscription: selectedsubscription ?? _selectedsubscription,
      henetworkStatus: henetworkStatus ?? _henetworkStatus,
      userid: userid ?? _userid,
      error: error ?? this.error,
    );
  }

  const DatabaseState.withError(
      {HenetworkStatus? henetworkStatus, Failure? error})
      : this._(
          listOfSubscriptionData: emptySubList,
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
      ];
}
