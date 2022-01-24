import 'answer.dart';

class QuestionerData {
  int? id;
  String? category;
  int? userRole;
  String? question;
  String? description;
  int? questionCategory;
  int? questionType;
  List<Answer>? answer;
  int? status;
  int? order;

  QuestionerData({
    this.id,
    this.category,
    this.userRole,
    this.question,
    this.description,
    this.questionCategory,
    this.questionType,
    this.answer,
    this.status,
    this.order,
  });

  factory QuestionerData.fromJson(Map<String, dynamic> json) {
    return QuestionerData(
      id: json['id'] as int?,
      category: json['category'] as String?,
      userRole: json['user_role'] as int?,
      question: json['question'] as String?,
      description: json['description'] as String?,
      questionCategory: json['question_category'] as int?,
      questionType: json['question_type'] as int?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'user_role': userRole,
        'question': question,
        'description': description,
        'question_category': questionCategory,
        'question_type': questionType,
        'answer': answer?.map((e) => e.toJson()).toList(),
        'status': status,
        'order': order,
      };
}
