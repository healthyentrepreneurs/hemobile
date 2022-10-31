import 'dart:convert';

import 'package:auth_repository/auth_repository.dart' hide Lang;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:he/helper/helper_functions.dart';
import 'package:he/langhe/langhe.dart';
part 'langhe_state.dart';

class LangHeCubit extends Cubit<LangHeState> {
  LangHeCubit(this._authenticationRepository) : super(const LangHeState());
  final AuthenticationRepository _authenticationRepository;
  Future<void> languagesFetched() async {
    try {
      Locale currentLanguage = await _authenticationRepository.currentLocale;
      if (state.status == LangHeStatus.initial) {
        final languages = await _fetchLanguages();
        return emit(state.copyWith(
            status: LangHeStatus.success,
            languages: languages,
            currentlanguage: currentLanguage));
      }
      final languages = await _fetchLanguages(state.languages.length);
      languages.isEmpty
          ? emit(state.copyWith(status: LangHeStatus.failure))
          : emit(
              state.copyWith(
                  status: LangHeStatus.success,
                  languages: List.of(state.languages)..addAll(languages),
                  currentlanguage: currentLanguage),
            );
    } catch (e) {
      printOnlyDebug(e);
      emit(state.copyWith(status: LangHeStatus.failure));
    }
  }

  Future<List<Lang>> _fetchLanguages([int startIndex = 0]) async {
    String languages = """{
    "languages":  [
    {
        "code": "en",
        "name": "English",
        "country": "US"
      },
      {
        "code": "es",
        "name": "Luganda",
        "country": "UGANDA"
      },
      {
        "code": "de",
        "name": "Runyankole",
        "country": "UGANDA"
      },
      {
        "code": "nn",
        "name": "Wanga",
        "country": "UGANDA"
      }
    ]}
      """;
    final body = json.decode(languages)['languages'] as List;
    return body.map((dynamic json) {
      return Lang(
        code: json['code'] as String,
        name: json['name'] as String,
        country: json['country'] as String,
      );
    }).toList();
  }

  Future<void> languageSelected(String langCode) async {
    try {
      int _state = await _authenticationRepository.setLocale(langCode);
      if (_state > 0) {
        Locale currentLanguage = await _authenticationRepository.currentLocale;
        emit(
          state.copyWith(
              status: LangHeStatus.success, currentlanguage: currentLanguage),
        );
      } else {
        // Locale currentLanguage = await _authenticationRepository.currentLocale;
        // emit(
        //   state.copyWith(currentlanguage: currentLanguage),
        // );
      }
    } catch (e) {
      printOnlyDebug("Zawede $e");
    }
  }
}
