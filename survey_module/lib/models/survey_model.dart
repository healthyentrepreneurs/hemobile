library survey_module;

/// The json converted to survey tool
/// https://jsontodart.com/
class SurveyObj {
  String title;
  List<Pages> pages;

  SurveyObj({this.title, this.pages});

  SurveyObj.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['pages'] != null) {
      pages = new List<Pages>();
      json['pages'].forEach((v) {
        pages.add(new Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.pages != null) {
      data['pages'] = this.pages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pages {
  String name;
  List<Elements> elements;
  String title;
  String description;
  String visibleIf;

  Pages(
      {this.name, this.elements, this.title, this.description, this.visibleIf});

  Pages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['elements'] != null) {
      elements = new List<Elements>();
      json['elements'].forEach((v) {
        elements.add(new Elements.fromJson(v));
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
      data['elements'] = this.elements.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['visibleIf'] = this.visibleIf;
    return data;
  }
}

class Elements {
  String type;
  String name;
  String title;
  bool isRequired;
  String acceptedTypes;
  bool waitForUpload;
  int maxSize;
  List<Choices> choices;
  String visibleIf;
  List<Validators> validators;
  int maxLength;
  String html;
  bool hasOther;
  String otherText;
  bool hasNone;
  String noneText;

  Elements(
      {this.type,
        this.name,
        this.title,
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
      choices = new List<Choices>();
      json['choices'].forEach((v) {
        choices.add(new Choices.fromJson(v));
      });
    }
    visibleIf = json['visibleIf'];
    if (json['validators'] != null) {
      validators = new List<Validators>();
      json['validators'].forEach((v) {
        validators.add(new Validators.fromJson(v));
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
      data['choices'] = this.choices.map((v) => v.toJson()).toList();
    }
    data['visibleIf'] = this.visibleIf;
    if (this.validators != null) {
      data['validators'] = this.validators.map((v) => v.toJson()).toList();
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
  String value;
  String text;

  Choices({this.value, this.text});

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
  String type;
  int minValue;
  int maxValue;

  Validators({this.type, this.minValue, this.maxValue});

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
