// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'db2/survey_nosql_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 6120176652095774955),
      name: 'SurveyDataModel',
      lastPropertyId: const IdUid(5, 2997715461575392851),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9193458994927258796),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 868818179976200058),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2346097745358634209),
            name: 'text',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8566832956739795144),
            name: 'isPending',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2997715461575392851),
            name: 'dateCreated',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 6241144381948706758),
      name: 'ViewsDataModel',
      lastPropertyId: const IdUid(6, 4703280388758880084),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 715154773590252573),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 6700487561596109073),
            name: 'bookId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1656244495468021869),
            name: 'courseId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 9043162735008476822),
            name: 'dateTimeStr',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4703280388758880084),
            name: 'chapterId',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 6241144381948706758),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [2498067145725140720],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    SurveyDataModel: EntityDefinition<SurveyDataModel>(
        model: _entities[0],
        toOneRelations: (SurveyDataModel object) => [],
        toManyRelations: (SurveyDataModel object) => {},
        getId: (SurveyDataModel object) => object.id,
        setId: (SurveyDataModel object, int id) {
          object.id = id;
        },
        objectToFB: (SurveyDataModel object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final textOffset = fbb.writeString(object.text);
          final dateCreatedOffset = object.dateCreated == null
              ? null
              : fbb.writeString(object.dateCreated!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, textOffset);
          fbb.addBool(3, object.isPending);
          fbb.addOffset(4, dateCreatedOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SurveyDataModel()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..name =
                const fb.StringReader().vTableGet(buffer, rootOffset, 6, '')
            ..text =
                const fb.StringReader().vTableGet(buffer, rootOffset, 8, '')
            ..isPending =
                const fb.BoolReader().vTableGetNullable(buffer, rootOffset, 10)
            ..dateCreated = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 12);

          return object;
        }),
    ViewsDataModel: EntityDefinition<ViewsDataModel>(
        model: _entities[1],
        toOneRelations: (ViewsDataModel object) => [],
        toManyRelations: (ViewsDataModel object) => {},
        getId: (ViewsDataModel object) => object.id,
        setId: (ViewsDataModel object, int id) {
          object.id = id;
        },
        objectToFB: (ViewsDataModel object, fb.Builder fbb) {
          final bookIdOffset = fbb.writeString(object.bookId);
          final courseIdOffset = fbb.writeString(object.courseId);
          final dateTimeStrOffset = fbb.writeString(object.dateTimeStr);
          final chapterIdOffset = fbb.writeString(object.chapterId);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, bookIdOffset);
          fbb.addOffset(3, courseIdOffset);
          fbb.addOffset(4, dateTimeStrOffset);
          fbb.addOffset(5, chapterIdOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ViewsDataModel()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..bookId =
                const fb.StringReader().vTableGet(buffer, rootOffset, 6, '')
            ..courseId =
                const fb.StringReader().vTableGet(buffer, rootOffset, 10, '')
            ..dateTimeStr =
                const fb.StringReader().vTableGet(buffer, rootOffset, 12, '')
            ..chapterId =
                const fb.StringReader().vTableGet(buffer, rootOffset, 14, '');

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [SurveyDataModel] entity fields to define ObjectBox queries.
class SurveyDataModel_ {
  /// see [SurveyDataModel.id]
  static final id =
      QueryIntegerProperty<SurveyDataModel>(_entities[0].properties[0]);

  /// see [SurveyDataModel.name]
  static final name =
      QueryStringProperty<SurveyDataModel>(_entities[0].properties[1]);

  /// see [SurveyDataModel.text]
  static final text =
      QueryStringProperty<SurveyDataModel>(_entities[0].properties[2]);

  /// see [SurveyDataModel.isPending]
  static final isPending =
      QueryBooleanProperty<SurveyDataModel>(_entities[0].properties[3]);

  /// see [SurveyDataModel.dateCreated]
  static final dateCreated =
      QueryStringProperty<SurveyDataModel>(_entities[0].properties[4]);
}

/// [ViewsDataModel] entity fields to define ObjectBox queries.
class ViewsDataModel_ {
  /// see [ViewsDataModel.id]
  static final id =
      QueryIntegerProperty<ViewsDataModel>(_entities[1].properties[0]);

  /// see [ViewsDataModel.bookId]
  static final bookId =
      QueryStringProperty<ViewsDataModel>(_entities[1].properties[1]);

  /// see [ViewsDataModel.courseId]
  static final courseId =
      QueryStringProperty<ViewsDataModel>(_entities[1].properties[2]);

  /// see [ViewsDataModel.dateTimeStr]
  static final dateTimeStr =
      QueryStringProperty<ViewsDataModel>(_entities[1].properties[3]);

  /// see [ViewsDataModel.chapterId]
  static final chapterId =
      QueryStringProperty<ViewsDataModel>(_entities[1].properties[4]);
}
