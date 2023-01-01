import 'package:flutter/material.dart';
import 'package:theme_locale_repo/generated/l10n.dart';

@immutable
class ThemeModel {
  const ThemeModel(this.themeData, this.themeId, this.themeTitle);
  final ThemeData themeData;
  final String themeId;
  final String Function(S) themeTitle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModel &&
          runtimeType == other.runtimeType &&
          themeData == other.themeData &&
          themeId == other.themeId &&
          themeTitle == other.themeTitle;

  @override
  int get hashCode =>
      themeData.hashCode ^ themeId.hashCode ^ themeTitle.hashCode;

  @override
  String toString() {
    return 'ThemeModel{themeData: $themeData, themeId: $themeId, themeTitle: $themeTitle}';
  }

//create a static final method
}
