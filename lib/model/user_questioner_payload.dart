class UserQuestionerPayload {
  int? questionnaireId;
  String? question;
  int? answer;
  dynamic answerDescription;

  UserQuestionerPayload({
    this.questionnaireId,
    this.question,
    this.answer,
    this.answerDescription,
  });

  factory UserQuestionerPayload.fromJson(Map<String, dynamic> json) {
    return UserQuestionerPayload(
      questionnaireId: json['questionnaire_id'] as int?,
      question: json['question'] as String?,
      answer: json['answer'] as int?,
      answerDescription: json['answer_description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'questionnaire_id': questionnaireId,
        'question': question,
        'answer': answer,
        'answer_description': answerDescription,
      };
}
