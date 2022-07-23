part of 'langhe_cubit.dart';

enum LangHeStatus { initial, success, failure }

class LangHeState extends Equatable {
  const LangHeState(
      {this.status = LangHeStatus.initial,
      this.languages = const <Lang>[],
      this.currentlanguage});
  final LangHeStatus status;
  final List<Lang> languages;
  final Locale? currentlanguage;

  @override
  List<Object?> get props => [status, currentlanguage, languages];

  LangHeState copyWith({
    LangHeStatus? status,
    List<Lang>? languages,
    Locale? currentlanguage,
  }) {
    return LangHeState(
      status: status ?? this.status,
      currentlanguage: currentlanguage ?? this.currentlanguage,
      languages: languages ?? this.languages,
    );
  }

  @override
  String toString() {
    return '''LangHeState { status: $status, current language $currentlanguage ,languages: ${languages.length} }''';
  }
}
