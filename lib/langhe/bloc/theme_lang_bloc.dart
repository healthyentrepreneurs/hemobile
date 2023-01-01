import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:theme_locale_repo/theme_locale_repo.dart';
import 'package:tuple/tuple.dart';

part 'theme_lang_event.dart';
part 'theme_lang_state.dart';

class ThemeLangBloc extends HydratedBloc<ThemeLangEvent, ThemeLangState> {
  final ThemeLocaleIntRepository themeLocaleIntRepository;
  ThemeLangBloc({
    required this.themeLocaleIntRepository,
  })  : _themeLocaleIntRepository = themeLocaleIntRepository,
        super(ThemeLangState.loading(
            inThemeLocale:
                themeLocaleIntRepository.themeAndLocale$.valueOrNull ??
                    themeLocaleIntRepository.defaultThemeAndLocale)) {
    on<ThemeStatusChanged>(_onThemeStatusChanged);
    on<LocaleStatusChanged>(_onLocaleStatusChanged);
    on<ThemeLocaleMessageChanged>(_onThemeLocaleMessageChanged);
    _themeAndLocaleSubscribtion =
        _themeLocaleIntRepository.themeAndLocale$.listen((event) {
      add(LocaleStatusChanged(event));
      // add(ThemeStatusChanged(event));
    });
    _messageSubscribtion = _themeLocaleIntRepository.message$.listen((event) {
      add(ThemeLocaleMessageChanged(event));
    });
  }
  final ThemeLocaleIntRepository _themeLocaleIntRepository;
  late final StreamSubscription<Tuple2<ThemeModel, Locale>>
      _themeAndLocaleSubscribtion;
  late final StreamSubscription<ChangeThemeLocaleMessage> _messageSubscribtion;

  _onThemeStatusChanged(
    ThemeStatusChanged event,
    Emitter<ThemeLangState> emit,
  ) async {
    _themeLocaleIntRepository.changeTheme(event.themeLocale.item1);
    emit(
      state.copyWith(themeLocale: event.themeLocale),
    );
  }

  _onLocaleStatusChanged(
    LocaleStatusChanged event,
    Emitter<ThemeLangState> emit,
  ) async {
    _themeLocaleIntRepository.changeLocale(event.themeLocale.item2);
    debugPrint('Sweet LocaleBloc ${event.themeLocale.item2}');
    emit(
      state.copyWith(themeLocale: event.themeLocale),
    );
  }

  @override
  Future<void> close() {
    _themeAndLocaleSubscribtion.cancel();
    _messageSubscribtion.cancel();
    _themeLocaleIntRepository.dispose();
    return super.close();
  }

  _onThemeLocaleMessageChanged(
      ThemeLocaleMessageChanged event, Emitter<ThemeLangState> emit) async {
    if (event.message is ChangeThemeSuccess) {
      emit(
        state.copyWith(status: ThemeLangStatus.changethemesuccess),
      );
    } else if (event.message is ChangeThemeFailure) {
      emit(
        state.copyWith(status: ThemeLangStatus.changethemefailure),
      );
    } else if (event.message is ChangeLocaleSuccess) {
      emit(
        state.copyWith(status: ThemeLangStatus.changelocalesuccess),
      );
    } else if (event.message is ChangeLocaleFailure) {
      emit(
        state.copyWith(status: ThemeLangStatus.changelocalefailure),
      );
    } else {
      emit(
        state.copyWith(status: ThemeLangStatus.loading),
      );
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    debugPrint('Jeje $error');
  }

  @override
  ThemeLangState? fromJson(Map<String, dynamic> json) {
    //create a new state from json
    return ThemeLangState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeLangState state) {
    //create a json from state
    return state.toJson();
  }
}
