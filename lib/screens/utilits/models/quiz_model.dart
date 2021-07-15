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
      {required this.slot,
      required this.page,
      required this.html,
      required this.sequencecheck,
      required this.lastactiontime,
      required this.hasautosavedstep,
      required this.flagged,
      required this.number,
      required this.status,
      required this.blockedbyprevious,
      required this.maxmark});

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
      {required this.id,
      required this.quiz,
      required this.userid,
      required this.attempt,
      required this.uniqueid,
      required this.layout,
      required this.currentpage,
      required this.preview,
      required this.state});

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

  Quiz({required this.id, required this.messages, required this.nextpage, required this.attempt, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      messages: json['messages'],
      nextpage: json['nextpage'],
      attempt: QuizAttempt.fromJson(json['attempt']),
      questions: (json['questions'] as List)
          .map((i) => QuizQuestion.fromJson(i))
          .toList(),
    );
  }
}
