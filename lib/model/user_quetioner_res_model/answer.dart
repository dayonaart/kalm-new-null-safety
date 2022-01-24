class Answer {
  int? id;
  String? answer;
  String? alert;

  Answer({this.id, this.answer, this.alert});

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as int?,
        answer: json['answer'] as String?,
        alert: json['alert'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'answer': answer,
        'alert': alert,
      };
}
