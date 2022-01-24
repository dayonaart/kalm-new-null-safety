import 'matchup_answer.dart';

class MatchupData {
  int? id;
  int? category;
  String? question;
  String? description;
  int? priority;
  int? isNoPreference;
  int? isCounselorDob;
  int? order;
  List<MatchupAnswer>? matchupAnswers;

  MatchupData({
    this.id,
    this.category,
    this.question,
    this.description,
    this.priority,
    this.isNoPreference,
    this.isCounselorDob,
    this.order,
    this.matchupAnswers,
  });

  factory MatchupData.fromJson(Map<String, dynamic> json) => MatchupData(
        id: json['id'] as int?,
        category: json['category'] as int?,
        question: json['question'] as String?,
        description: json['description'] as String?,
        priority: json['priority'] as int?,
        isNoPreference: json['is_no_preference'] as int?,
        isCounselorDob: json['is_counselor_dob'] as int?,
        order: json['order'] as int?,
        matchupAnswers: (json['matchup_answers'] as List<dynamic>?)
            ?.map((e) => MatchupAnswer.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'question': question,
        'description': description,
        'priority': priority,
        'is_no_preference': isNoPreference,
        'is_counselor_dob': isCounselorDob,
        'order': order,
        'matchup_answers': matchupAnswers?.map((e) => e.toJson()).toList(),
      };
}
