class QuizQuestion {
  int slot;
  int page;
  String html;
  int sequencecheck;
  int lastactiontime;
  bool hasautosavedstep;
  bool flagged;
  int number;
  String status;
  bool blockedbyprevious;
  int maxmark;

  QuizQuestion(
      {this.slot,
      this.page,
      this.html,
      this.sequencecheck,
      this.lastactiontime,
      this.hasautosavedstep,
      this.flagged,
      this.number,
      this.status,
      this.blockedbyprevious,
      this.maxmark});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      slot: json['slot'],
      page: json['page'],
      html: json['html'],
      sequencecheck: json['sequencecheck'],
      lastactiontime: json['lastactiontime'],
      hasautosavedstep: json['hasautosavedstep'],
      flagged: json['flagged'],
      number: json['number'],
      status: json['status'],
      blockedbyprevious: json['blockedbyprevious'],
      maxmark: json['maxmark'],
    );
  }
}

class QuizAttempt {
  int id;
  int quiz;
  int userid;
  int attempt;
  int uniqueid;
  String layout;
  int currentpage;
  int preview;
  String state;

  QuizAttempt(
      {this.id,
      this.quiz,
      this.userid,
      this.attempt,
      this.uniqueid,
      this.layout,
      this.currentpage,
      this.preview,
      this.state});

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
        id: json['id'],
        quiz: json['quiz'],
        userid: json['userid'],
        attempt: json['attempt'],
        uniqueid: json['uniqueid'],
        layout: json['layout'],
        currentpage: json['currentpage'],
        preview: json['preview'],
        state: json['state']);
  }
}

class Quiz {
  int id;
  List<dynamic> messages;
  int nextpage;
  QuizAttempt attempt;
  List<QuizQuestion> questions;

  Quiz({this.id, this.messages, this.nextpage, this.attempt, this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      messages: json['messages'],
      nextpage: json['nextpage'],
      attempt: QuizAttempt.fromJson(json['attempt']),
      questions: (json['questions'] as List)
          ?.map((i) => QuizQuestion.fromJson(i))
          ?.toList(),
    );
  }
}
