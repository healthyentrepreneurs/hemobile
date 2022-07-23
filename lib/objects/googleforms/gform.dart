import 'dart:convert';

import 'info.dart';
import 'item.dart';
import 'settings.dart';

GForm gformFromJson(String str) => GForm.fromJson(json.decode(str));

String gformToJson(GForm data) => json.encode(data.toJson());

class GForm {
  GForm({
    required this.formId,
    required this.info,
    required this.settings,
    required this.revisionId,
    required this.responderUri,
    required this.items,
    this.linkedSheetId,
  });

  String formId;
  Info info;
  Settings settings;
  String revisionId;
  String responderUri;
  List<Item> items;
  String? linkedSheetId;

  factory GForm.fromJson(Map<String, dynamic> json) => GForm(
        formId: json["formId"],
        info: Info.fromJson(json["info"]),
        settings: Settings.fromJson(json["settings"]),
        revisionId: json["revisionId"],
        responderUri: json["responderUri"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        linkedSheetId: json["linkedSheetId"],
      );

  Map<String, dynamic> toJson() => {
        "formId": formId,
        "info": info.toJson(),
        "settings": settings.toJson(),
        "revisionId": revisionId,
        "responderUri": responderUri,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "linkedSheetId": linkedSheetId,
      };
}
