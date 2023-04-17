part of 'survey_bloc.dart';

class SurveyState extends Equatable {
  const SurveyState._({
    String? surveyjson,
    HenetworkStatus? henetworkStatus,
    this.error,
    this.saveError,
    this.surveySavedId, // Added field
  })  : _surveyjson = surveyjson,
        _henetworkStatus = henetworkStatus ?? HenetworkStatus.loading;

  final String? _surveyjson;
  final HenetworkStatus _henetworkStatus;
  final Failure? error;
  final Failure? saveError;
  final String? surveySavedId; // Added field

  const SurveyState.loading({
    String? surveyjson,
    HenetworkStatus? henetworkStatus,
  }) : this._(
          surveyjson: surveyjson,
          henetworkStatus: henetworkStatus,
        );

  const SurveyState.reset() : this._(surveyjson: null, surveySavedId: null);

  SurveyState copyWith({
    String? surveyjson,
    HenetworkStatus? henetworkStatus,
    Failure? error,
    Failure? saveError,
    String? surveySavedId, // Added field
  }) {
    return SurveyState._(
      surveyjson: surveyjson ?? _surveyjson,
      henetworkStatus: henetworkStatus ?? _henetworkStatus,
      error: error ?? this.error,
      saveError: saveError ?? this.saveError,
      surveySavedId: surveySavedId ?? this.surveySavedId, // Added field
    );
  }

  String? get gsurveyjson => _surveyjson;
  HenetworkStatus get ghenetworkStatus => _henetworkStatus;

  @override
  List<Object?> get props => [
        gsurveyjson,
        ghenetworkStatus,
        error,
        saveError,
        surveySavedId
      ]; // Added field
}
