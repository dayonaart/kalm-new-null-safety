class MatchupJson {
  int? question;
  int? priority;
  List<int>? answer;

  MatchupJson({this.question, this.priority, this.answer});

  factory MatchupJson.fromJson(Map<String, dynamic> json) => MatchupJson(
        question: json['question'] as int?,
        priority: json['priority'] as int?,
        answer: json['answer'] as List<int>?,
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'priority': priority,
        'answer': answer,
      };
}
