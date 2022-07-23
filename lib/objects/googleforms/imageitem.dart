import 'gimage.dart';

class ImageItem {
  ImageItem({
    required this.image,
  });

  Gimage image;

  factory ImageItem.fromJson(Map<String, dynamic> json) => ImageItem(
        image: Gimage.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "image": image.toJson(),
      };
}
