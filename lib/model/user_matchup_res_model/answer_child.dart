class AnswerChild {
  int? id;
  String? answer;
  int? order;

  AnswerChild({this.id, this.answer, this.order});

  factory AnswerChild.fromJson(Map<String, dynamic> json) => AnswerChild(
        id: json['id'] as int?,
        answer: json['answer'] as String?,
        order: json['order'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'answer': answer,
        'order': order,
      };
}
