// GENERATED CODE - DO NOT MODIFY BY HAND

// Currently loading model from "JSON" which always encodes with double quotes
// ignore_for_file: prefer_single_quotes

import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';
import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'db2/survey_nosql_model.dart';

ModelDefinition getObjectBoxModel() {
  final model = ModelInfo.fromMap({
    "entities": [
      {
        "id": "1:6120176652095774955",
        "lastPropertyId": "5:2997715461575392851",
        "name": "SurveyDataModel",
        "properties": [
          {"id": "1:9193458994927258796", "name": "id", "type": 6, "flags": 1},
          {"id": "2:868818179976200058", "name": "name", "type": 9},
          {"id": "3:2346097745358634209", "name": "text", "type": 9},
          {"id": "4:8566832956739795144", "name": "isPending", "type": 1},
          {"id": "5:2997715461575392851", "name": "dateCreated", "type": 9}
        ],
        "relations": [],
        "backlinks": []
      },
      {
        "id": "2:6241144381948706758",
        "lastPropertyId": "6:4703280388758880084",
        "name": "ViewsDataModel",
        "properties": [
          {"id": "1:715154773590252573", "name": "id", "type": 6, "flags": 1},
          {"id": "2:6700487561596109073", "name": "bookId", "type": 9},
          {"id": "4:1656244495468021869", "name": "courseId", "type": 9},
          {"id": "5:9043162735008476822", "name": "dateTimeStr", "type": 9},
          {"id": "6:4703280388758880084", "name": "chapterId", "type": 9}
        ],
        "relations": [],
        "backlinks": []
      }
    ],
    "lastEntityId": "2:6241144381948706758",
    "lastIndexId": "0:0",
    "lastRelationId": "0:0",
    "lastSequenceId": "0:0",
    "modelVersion": 5
  }, check: false);

  final bindings = <Type, EntityDefinition>{};
  bindings[SurveyDataModel] = EntityDefinition<SurveyDataModel>(
      model: model.getEntityByUid(6120176652095774955),
      toOneRelations: (SurveyDataModel object) => [],
      toManyRelations: (SurveyDataModel object) => {},
      getId: (SurveyDataModel object) => object.id,
      setId: (SurveyDataModel object, int id) {
        object.id = id;
      },
      objectToFB: (SurveyDataModel object, fb.Builder fbb) {
        final offsetname =
            object.name == null ? null : fbb.writeString(object.name);
        final offsettext =
            object.text == null ? null : fbb.writeString(object.text);
        final offsetdateCreated = object.dateCreated == null
            ? null
            : fbb.writeString(object.dateCreated);
        fbb.startTable();
        fbb.addInt64(0, object.id ?? 0);
        fbb.addOffset(1, offsetname);
        fbb.addOffset(2, offsettext);
        fbb.addBool(3, object.isPending);
        fbb.addOffset(4, offsetdateCreated);
        fbb.finish(fbb.endTable());
        return object.id ?? 0;
      },
      objectFromFB: (Store store, Uint8List fbData) {
        final buffer = fb.BufferContext.fromBytes(fbData);
        final rootOffset = buffer.derefObject(0);

        final object = SurveyDataModel();
        object.id = fb.Int64Reader().vTableGet(buffer, rootOffset, 4);
        object.name = fb.StringReader().vTableGet(buffer, rootOffset, 6);
        object.text = fb.StringReader().vTableGet(buffer, rootOffset, 8);
        object.isPending = fb.BoolReader().vTableGet(buffer, rootOffset, 10);
        object.dateCreated =
            fb.StringReader().vTableGet(buffer, rootOffset, 12);
        return object;
      });
  bindings[ViewsDataModel] = EntityDefinition<ViewsDataModel>(
      model: model.getEntityByUid(6241144381948706758),
      toOneRelations: (ViewsDataModel object) => [],
      toManyRelations: (ViewsDataModel object) => {},
      getId: (ViewsDataModel object) => object.id,
      setId: (ViewsDataModel object, int id) {
        object.id = id;
      },
      objectToFB: (ViewsDataModel object, fb.Builder fbb) {
        final offsetbookId =
            object.bookId == null ? null : fbb.writeString(object.bookId);
        final offsetcourseId =
            object.courseId == null ? null : fbb.writeString(object.courseId);
        final offsetdateTimeStr = object.dateTimeStr == null
            ? null
            : fbb.writeString(object.dateTimeStr);
        final offsetchapterId =
            object.chapterId == null ? null : fbb.writeString(object.chapterId);
        fbb.startTable();
        fbb.addInt64(0, object.id ?? 0);
        fbb.addOffset(1, offsetbookId);
        fbb.addOffset(3, offsetcourseId);
        fbb.addOffset(4, offsetdateTimeStr);
        fbb.addOffset(5, offsetchapterId);
        fbb.finish(fbb.endTable());
        return object.id ?? 0;
      },
      objectFromFB: (Store store, Uint8List fbData) {
        final buffer = fb.BufferContext.fromBytes(fbData);
        final rootOffset = buffer.derefObject(0);

        final object = ViewsDataModel();
        object.id = fb.Int64Reader().vTableGet(buffer, rootOffset, 4);
        object.bookId = fb.StringReader().vTableGet(buffer, rootOffset, 6);
        object.courseId = fb.StringReader().vTableGet(buffer, rootOffset, 10);
        object.dateTimeStr =
            fb.StringReader().vTableGet(buffer, rootOffset, 12);
        object.chapterId = fb.StringReader().vTableGet(buffer, rootOffset, 14);
        return object;
      });

  return ModelDefinition(model, bindings);
}

class SurveyDataModel_ {
  static final id =
      QueryIntegerProperty(entityId: 1, propertyId: 1, obxType: 6);
  static final name =
      QueryStringProperty(entityId: 1, propertyId: 2, obxType: 9);
  static final text =
      QueryStringProperty(entityId: 1, propertyId: 3, obxType: 9);
  static final isPending =
      QueryBooleanProperty(entityId: 1, propertyId: 4, obxType: 1);
  static final dateCreated =
      QueryStringProperty(entityId: 1, propertyId: 5, obxType: 9);
}

class ViewsDataModel_ {
  static final id =
      QueryIntegerProperty(entityId: 2, propertyId: 1, obxType: 6);
  static final bookId =
      QueryStringProperty(entityId: 2, propertyId: 2, obxType: 9);
  static final courseId =
      QueryStringProperty(entityId: 2, propertyId: 4, obxType: 9);
  static final dateTimeStr =
      QueryStringProperty(entityId: 2, propertyId: 5, obxType: 9);
  static final chapterId =
      QueryStringProperty(entityId: 2, propertyId: 6, obxType: 9);
}
