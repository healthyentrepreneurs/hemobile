import 'imageitem.dart';
import 'questionitem.dart';
import 'videoitem.dart';

class Item {
  Item({
    required this.itemId,
    required this.title,
    this.questionItem,
    this.videoItem,
    this.imageItem,
  });

  String itemId;
  String title;
  QuestionItem? questionItem;
  VideoItem? videoItem;
  ImageItem? imageItem;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["itemId"],
        title: json["title"],
        questionItem: json["questionItem"] == null
            ? null
            : QuestionItem.fromJson(json["questionItem"]),
        videoItem: json["videoItem"] == null
            ? null
            : VideoItem.fromJson(json["videoItem"]),
        imageItem: json["imageItem"] == null
            ? null
            : ImageItem.fromJson(json["imageItem"]),
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "title": title,
        "questionItem": questionItem == null ? null : questionItem!.toJson(),
        "videoItem": videoItem == null ? null : videoItem!.toJson(),
        "imageItem": imageItem == null ? null : imageItem!.toJson(),
      };
}
