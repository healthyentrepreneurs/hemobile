class Grading {
  Grading({
    this.pointValue,
  });

  int? pointValue;

  factory Grading.fromJson(Map<String, dynamic> json) => Grading(
    pointValue: json["pointValue"],
  );

  Map<String, dynamic> toJson() => {
    "pointValue": pointValue,
  };
}