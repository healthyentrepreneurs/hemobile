class Option {
  Option({
    required this.value,
  });

  String value;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
  };
}