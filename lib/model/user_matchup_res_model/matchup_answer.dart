import 'answer_child.dart';

class MatchupAnswer {
  int? id;
  String? answer;
  int? priority;
  int? order;
  List<AnswerChild>? answerChildren;

  MatchupAnswer({
    this.id,
    this.answer,
    this.priority,
    this.order,
    this.answerChildren,
  });

  factory MatchupAnswer.fromJson(Map<String, dynamic> json) => MatchupAnswer(
        id: json['id'] as int?,
        answer: json['answer'] as String?,
        priority: json['priority'] as int?,
        order: json['order'] as int?,
        answerChildren: (json['answer_children'] as List<dynamic>?)
            ?.map((e) => AnswerChild.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'answer': answer,
        'priority': priority,
        'order': order,
        'answer_children': answerChildren?.map((e) => e.toJson()).toList(),
      };
}
