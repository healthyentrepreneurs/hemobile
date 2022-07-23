import 'gvideo.dart';

class VideoItem {
  VideoItem({
    required this.video,
  });

  Gvideo video;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
        video: Gvideo.fromJson(json["video"]),
      );

  Map<String, dynamic> toJson() => {
        "video": video.toJson(),
      };
}
