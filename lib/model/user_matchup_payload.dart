class UserMatchupPayload {
  int? question;
  List<int?>? answer;

  UserMatchupPayload({
    this.question,
    this.answer,
  });

  factory UserMatchupPayload.fromJson(Map<String, dynamic> json) {
    return UserMatchupPayload(
      question: json['question'] as int,
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };
}
