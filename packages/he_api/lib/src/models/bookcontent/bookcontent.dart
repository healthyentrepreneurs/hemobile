import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:he_api/he_api.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enum_converters.dart';

part 'bookcontent.g.dart';

@JsonSerializable(explicitToJson: true)
@CopyWith()
class BookContent extends Equatable {
  factory BookContent.fromJson(
    Map<String, dynamic> json, {
    bool readUrlFlag = false,
  }) {
    final bookContent = _$BookContentFromJson(json);
    return bookContent._updateFileUrlIfNeeded(readUrlFlag);
  }
  BookContent({
    this.id,
    required this.type,
    required this.filename,
    required this.filepath,
    required this.filesize,
    this.fileurl,
    this.timecreated,
    this.timemodified,
    this.sortorder,
    this.userid,
    this.content,
    this.mimetype,
    this.videocaption,
    this.readUrlFlag = false,
  });

  final int? id;

  @TypeConverter()
  final Type type;

  final String filename;
  final String filepath;
  final int filesize;
  final String? fileurl;
  final int? timecreated;
  final int? timemodified;
  final int? sortorder;
  final double? userid;
  final String? content;

  @MimetypeConverter()
  final Mimetype? mimetype;

  final String? videocaption;
  final bool readUrlFlag;

  BookContent _updateFileUrlIfNeeded(bool readUrlFlag) {
    if (readUrlFlag) {
      // String? newFileUrl =
      //     '<h1>Contents in html</h1>'; // Replace this line with the actual logic
      // return copyWith(fileurl: newFileUrl);
    }
    return this;
  }

  Map<String, dynamic> toJson() => _$BookContentToJson(this);

  @override
  List<Object?> get props => [
        id,
        type,
        filename,
        filepath,
        filesize,
        fileurl,
        timecreated,
        timemodified,
        sortorder,
        userid,
        content,
        mimetype,
        videocaption,
      ];

  String? get fileUrl {
    return fileurl;
  }
}

enum Mimetype { VIDEO_MP4, IMAGE_PNG, IMAGE_JPEG }

enum Type { CONTENT, FILE }
