// To parse this JSON data, do
class ObjectSubscription {
  ObjectSubscription({
    required this.id,
    this.fullname,
    this.categoryid,
    this.source,
    this.summaryCustome,
    this.nextLink,
    this.imageUrlSmall,
    this.imageUrl,
  });

  int id;
  String? fullname;
  int? categoryid;
  String? source;
  String? summaryCustome;
  String? nextLink;
  String? imageUrlSmall;
  String? imageUrl;

  factory ObjectSubscription.fromJson(Map<String, dynamic> json) =>
      ObjectSubscription(
        id: json["id"],
        fullname: json["fullname"],
        categoryid: json["categoryid"],
        source: json["source"],
        summaryCustome: json["summary_custome"],
        nextLink: json["next_link"],
        imageUrlSmall: json["image_url_small"],
        imageUrl: json["image_url"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "categoryid": categoryid,
        "source": source,
        "summary_custome": summaryCustome,
        "next_link": nextLink,
        "image_url_small": imageUrlSmall,
        "image_url": imageUrl,
      };
}
