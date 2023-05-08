// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookcontent.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookContentCWProxy {
  BookContent id(int? id);

  BookContent type(Type type);

  BookContent filename(String filename);

  BookContent filepath(String filepath);

  BookContent filesize(int filesize);

  BookContent fileurl(String? fileurl);

  BookContent timecreated(int? timecreated);

  BookContent timemodified(int? timemodified);

  BookContent sortorder(int? sortorder);

  BookContent userid(double? userid);

  BookContent content(String? content);

  BookContent mimetype(Mimetype? mimetype);

  BookContent videocaption(String? videocaption);

  BookContent readUrlFlag(bool readUrlFlag);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookContent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookContent(...).copyWith(id: 12, name: "My name")
  /// ````
  BookContent call({
    int? id,
    Type? type,
    String? filename,
    String? filepath,
    int? filesize,
    String? fileurl,
    int? timecreated,
    int? timemodified,
    int? sortorder,
    double? userid,
    String? content,
    Mimetype? mimetype,
    String? videocaption,
    bool? readUrlFlag,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookContent.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookContent.copyWith.fieldName(...)`
class _$BookContentCWProxyImpl implements _$BookContentCWProxy {
  const _$BookContentCWProxyImpl(this._value);

  final BookContent _value;

  @override
  BookContent id(int? id) => this(id: id);

  @override
  BookContent type(Type type) => this(type: type);

  @override
  BookContent filename(String filename) => this(filename: filename);

  @override
  BookContent filepath(String filepath) => this(filepath: filepath);

  @override
  BookContent filesize(int filesize) => this(filesize: filesize);

  @override
  BookContent fileurl(String? fileurl) => this(fileurl: fileurl);

  @override
  BookContent timecreated(int? timecreated) => this(timecreated: timecreated);

  @override
  BookContent timemodified(int? timemodified) =>
      this(timemodified: timemodified);

  @override
  BookContent sortorder(int? sortorder) => this(sortorder: sortorder);

  @override
  BookContent userid(double? userid) => this(userid: userid);

  @override
  BookContent content(String? content) => this(content: content);

  @override
  BookContent mimetype(Mimetype? mimetype) => this(mimetype: mimetype);

  @override
  BookContent videocaption(String? videocaption) =>
      this(videocaption: videocaption);

  @override
  BookContent readUrlFlag(bool readUrlFlag) => this(readUrlFlag: readUrlFlag);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookContent(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookContent(...).copyWith(id: 12, name: "My name")
  /// ````
  BookContent call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? filename = const $CopyWithPlaceholder(),
    Object? filepath = const $CopyWithPlaceholder(),
    Object? filesize = const $CopyWithPlaceholder(),
    Object? fileurl = const $CopyWithPlaceholder(),
    Object? timecreated = const $CopyWithPlaceholder(),
    Object? timemodified = const $CopyWithPlaceholder(),
    Object? sortorder = const $CopyWithPlaceholder(),
    Object? userid = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? mimetype = const $CopyWithPlaceholder(),
    Object? videocaption = const $CopyWithPlaceholder(),
    Object? readUrlFlag = const $CopyWithPlaceholder(),
  }) {
    return BookContent(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as Type,
      filename: filename == const $CopyWithPlaceholder() || filename == null
          ? _value.filename
          // ignore: cast_nullable_to_non_nullable
          : filename as String,
      filepath: filepath == const $CopyWithPlaceholder() || filepath == null
          ? _value.filepath
          // ignore: cast_nullable_to_non_nullable
          : filepath as String,
      filesize: filesize == const $CopyWithPlaceholder() || filesize == null
          ? _value.filesize
          // ignore: cast_nullable_to_non_nullable
          : filesize as int,
      fileurl: fileurl == const $CopyWithPlaceholder()
          ? _value.fileurl
          // ignore: cast_nullable_to_non_nullable
          : fileurl as String?,
      timecreated: timecreated == const $CopyWithPlaceholder()
          ? _value.timecreated
          // ignore: cast_nullable_to_non_nullable
          : timecreated as int?,
      timemodified: timemodified == const $CopyWithPlaceholder()
          ? _value.timemodified
          // ignore: cast_nullable_to_non_nullable
          : timemodified as int?,
      sortorder: sortorder == const $CopyWithPlaceholder()
          ? _value.sortorder
          // ignore: cast_nullable_to_non_nullable
          : sortorder as int?,
      userid: userid == const $CopyWithPlaceholder()
          ? _value.userid
          // ignore: cast_nullable_to_non_nullable
          : userid as double?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      mimetype: mimetype == const $CopyWithPlaceholder()
          ? _value.mimetype
          // ignore: cast_nullable_to_non_nullable
          : mimetype as Mimetype?,
      videocaption: videocaption == const $CopyWithPlaceholder()
          ? _value.videocaption
          // ignore: cast_nullable_to_non_nullable
          : videocaption as String?,
      readUrlFlag:
          readUrlFlag == const $CopyWithPlaceholder() || readUrlFlag == null
              ? _value.readUrlFlag
              // ignore: cast_nullable_to_non_nullable
              : readUrlFlag as bool,
    );
  }
}

extension $BookContentCopyWith on BookContent {
  /// Returns a callable class that can be used as follows: `instanceOfBookContent.copyWith(...)` or like so:`instanceOfBookContent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookContentCWProxy get copyWith => _$BookContentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookContent _$BookContentFromJson(Map<String, dynamic> json) => BookContent(
      id: json['id'] as int?,
      type: const TypeConverter().fromJson(json['type'] as String),
      filename: json['filename'] as String,
      filepath: json['filepath'] as String,
      filesize: json['filesize'] as int,
      fileurl: json['fileurl'] as String?,
      timecreated: json['timecreated'] as int?,
      timemodified: json['timemodified'] as int?,
      sortorder: json['sortorder'] as int?,
      userid: (json['userid'] as num?)?.toDouble(),
      content: json['content'] as String?,
      mimetype: _$JsonConverterFromJson<String, Mimetype>(
          json['mimetype'], const MimetypeConverter().fromJson),
      videocaption: json['videocaption'] as String?,
      readUrlFlag: json['readUrlFlag'] as bool? ?? false,
    );

Map<String, dynamic> _$BookContentToJson(BookContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': const TypeConverter().toJson(instance.type),
      'filename': instance.filename,
      'filepath': instance.filepath,
      'filesize': instance.filesize,
      'fileurl': instance.fileurl,
      'timecreated': instance.timecreated,
      'timemodified': instance.timemodified,
      'sortorder': instance.sortorder,
      'userid': instance.userid,
      'content': instance.content,
      'mimetype': _$JsonConverterToJson<String, Mimetype>(
          instance.mimetype, const MimetypeConverter().toJson),
      'videocaption': instance.videocaption,
      'readUrlFlag': instance.readUrlFlag,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
