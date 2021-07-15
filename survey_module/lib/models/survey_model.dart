library survey_module;

/// The json converted to survey tool
/// https://jsontodart.com/
class SurveyObj {
  late String title;
  List<Pages>? pages;

  SurveyObj({required this.title,this.pages});

  SurveyObj.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['pages'] != null) {
      pages = <Pages>[];
      json['pages'].forEach((v) {
        pages!.add(new Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.pages != null) {
      data['pages'] = this.pages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pages {
  late String name;
  List<Elements>? elements;
  late String title;
  late String description;
  late String visibleIf;

  Pages(
      {required this.name, this.elements,
      required this.title,
      required this.description,
      required this.visibleIf});

  Pages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['elements'] != null) {
      elements = <Elements>[];
      json['elements'].forEach((v) {
        elements!.add(new Elements.fromJson(v));
      });
    }
    title = json['title'];
    description = json['description'];
    visibleIf = json['visibleIf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.elements != null) {
      data['elements'] = this.elements!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['visibleIf'] = this.visibleIf;
    return data;
  }
}

class Elements {
  late String type;
  late String name;
  late String title;
  bool? isRequired;
  String? acceptedTypes;
  bool? waitForUpload;
  int? maxSize;
  List<Choices>? choices;
  String? visibleIf;
  List<Validators>? validators;
  int? maxLength;
  String? html;
  bool? hasOther;
  String? otherText;
  bool? hasNone;
  String? noneText;

  Elements(
      {required this.type,
      required this.name,
      required this.title,
      this.isRequired,
      this.acceptedTypes,
      this.waitForUpload,
      this.maxSize,
      this.choices,
      this.visibleIf,
      this.validators,
      this.maxLength,
      this.html,
      this.hasOther,
      this.otherText,
      this.hasNone,
      this.noneText});

  Elements.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    title = json['title'];
    isRequired = json['isRequired'];
    acceptedTypes = json['acceptedTypes'];
    waitForUpload = json['waitForUpload'];
    maxSize = json['maxSize'];
    if (json['choices'] != null) {
      // choices = new List<Choices>();
      choices= <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(new Choices.fromJson(v));
      });
    }
    visibleIf = json['visibleIf'];
    if (json['validators'] != null) {
      validators= <Validators>[];
      json['validators'].forEach((v) {
        validators!.add(new Validators.fromJson(v));
      });
    }
    maxLength = json['maxLength'];
    html = json['html'];
    hasOther = json['hasOther'];
    otherText = json['otherText'];
    hasNone = json['hasNone'];
    noneText = json['noneText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['title'] = this.title;
    data['isRequired'] = this.isRequired;
    data['acceptedTypes'] = this.acceptedTypes;
    data['waitForUpload'] = this.waitForUpload;
    data['maxSize'] = this.maxSize;
    if (this.choices != null) {
      data['choices'] = this.choices!.map((v) => v.toJson()).toList();
    }
    data['visibleIf'] = this.visibleIf;
    if (this.validators != null) {
      data['validators'] = this.validators!.map((v) => v.toJson()).toList();
    }
    data['maxLength'] = this.maxLength;
    data['html'] = this.html;
    data['hasOther'] = this.hasOther;
    data['otherText'] = this.otherText;
    data['hasNone'] = this.hasNone;
    data['noneText'] = this.noneText;
    return data;
  }
}

class Choices {
  late String value;
  late String text;
  Choices({required this.value, required this.text});
  Choices.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}

class Validators {
  late String type;
  late int minValue;
  late int maxValue;

  Validators(
      {required this.type, required this.minValue, required this.maxValue});

  Validators.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    minValue = json['minValue'];
    maxValue = json['maxValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['minValue'] = this.minValue;
    data['maxValue'] = this.maxValue;
    return data;
  }
}
