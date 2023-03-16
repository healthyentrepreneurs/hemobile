// enum_converters.dart

import 'package:json_annotation/json_annotation.dart';
import 'bookcontent.dart';

// enum_converters.dart

class MimetypeConverter implements JsonConverter<Mimetype, String> {
  const MimetypeConverter();

  @override
  Mimetype fromJson(String json) {
    return Mimetype.values.firstWhere((e) => _enumToString(e) == json);
  }

  @override
  String toJson(Mimetype object) {
    return _enumToString(object);
  }

  String _enumToString(Mimetype mimetype) {
    switch (mimetype) {
      case Mimetype.IMAGE_JPEG:
        return 'image/jpeg';
      case Mimetype.IMAGE_PNG:
        return 'image/png';
      case Mimetype.VIDEO_MP4:
        return 'video/mp4';
      default:
        throw Exception('Unknown mimetype');
    }
  }
}

class TypeConverter implements JsonConverter<Type, String> {
  const TypeConverter();

  @override
  Type fromJson(String json) {
    return Type.values.firstWhere((e) =>
        e.toString().split('.').last.toLowerCase() == json.toLowerCase());
  }

  @override
  String toJson(Type object) {
    return object.toString().split('.').last.toLowerCase();
  }
}
