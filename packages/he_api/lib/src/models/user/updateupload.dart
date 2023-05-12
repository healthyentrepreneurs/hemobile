import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'updateupload.g.dart';

/// {@template updateupload}
// @immutable
// @JsonSerializable()
@JsonSerializable(explicitToJson: true)
class UpdateUpload extends Equatable {
  final int? id;
  final double? uploadProgress;
  final bool? isUploadingData;
  final bool? backupAnimation;
  final bool? surveyAnimation;
  final bool? booksAnimation;

  /// {@macro UpdateUpload}
  const UpdateUpload({
    this.id,
    this.uploadProgress,
    this.isUploadingData,
    this.backupAnimation,
    this.surveyAnimation,
    this.booksAnimation,
  });

  factory UpdateUpload.fromJson(Map<String, dynamic> json) =>
      _$UpdateUploadFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUploadToJson(this);

  static const empty = UpdateUpload(id: 0);

  bool get isEmpty => this == UpdateUpload.empty;

  bool get isNotEmpty => this != UpdateUpload.empty;

  UpdateUpload copyWith({
    int? id,
    double? uploadProgress,
    bool? isUploadingData,
    bool? backupAnimation,
    bool? surveyAnimation,
    bool? booksAnimation,
  }) {
    return UpdateUpload(
      id: id ?? this.id,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploadingData: isUploadingData ?? this.isUploadingData,
      backupAnimation: backupAnimation ?? this.backupAnimation,
      surveyAnimation: surveyAnimation ?? this.surveyAnimation,
      booksAnimation: booksAnimation ?? this.booksAnimation,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uploadProgress,
        isUploadingData,
        backupAnimation,
        surveyAnimation,
        booksAnimation
      ];

  static final toUpdateUploadOrNull = (Object? s) => s == null
      ? null
      : UpdateUpload.fromJson(
    jsonDecode(s as String) as Map<String, dynamic>,
  );

  static final toUpdateUploadOrEmpty = (Object? s) => s == null
      ? UpdateUpload.empty
      : UpdateUpload.fromJson(
    jsonDecode(s as String) as Map<String, dynamic>,
  );

  static Future<UpdateUpload?> toUpdateUploadOrNullFuture(Object? s) async => s == null
      ? null
      : UpdateUpload.fromJson(jsonDecode(s as String) as Map<String, dynamic>);

  static String? updateUploadToString(UpdateUpload? u) =>
      u == null ? null : jsonEncode(u);

  static Future<String?> updateUploadToStringFuture(UpdateUpload? u) async =>
      u == null ? null : jsonEncode(u);
}
