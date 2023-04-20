part of 'database_bloc.dart';

const emptySub = <Subscription>[];

@immutable
class DatabaseState extends Equatable {
  const DatabaseState._({
    List<Subscription?>? listOfSubscriptionData,
    HenetworkStatus? henetworkStatus,
    String? userid,
    Subscription? selectedsubscription,
    this.error,
    this.fetchError,
    this.surveyTotalCount,
    this.uploadProgress,
    this.isUploadingData,
    this.backupAnimation,
    this.surveyAnimation,
    this.booksAnimation,
  })  : _userid = userid ?? '',
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
  //Uploading Start
  final double? uploadProgress;
  final bool? isUploadingData;
  final bool? backupAnimation;
  final bool? surveyAnimation;
  final bool? booksAnimation;
  //Uploading End

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
      int? surveyTotalCount,
      double? uploadProgress,
      bool? isUploadingData,
      bool? backupAnimation,
      bool? surveyAnimation,
      bool? booksAnimation}) {
    return DatabaseState._(
        listOfSubscriptionData:
            listOfSubscriptionData ?? _listOfSubscriptionData,
        selectedsubscription: selectedsubscription ?? _selectedsubscription,
        henetworkStatus: henetworkStatus ?? _henetworkStatus,
        userid: userid ?? _userid,
        error: error ?? this.error,
        fetchError: fetchError ?? this.fetchError,
        surveyTotalCount: surveyTotalCount ?? this.surveyTotalCount,
        //Uploading
        uploadProgress: uploadProgress ?? this.uploadProgress,
        isUploadingData: isUploadingData ?? this.isUploadingData,
        backupAnimation: backupAnimation ?? this.backupAnimation,
        surveyAnimation: surveyAnimation ?? this.surveyAnimation,
        booksAnimation: booksAnimation ?? this.booksAnimation);
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
        surveyTotalCount,
        uploadProgress,
        isUploadingData,
        backupAnimation,
        surveyAnimation,
        booksAnimation
      ];
}
