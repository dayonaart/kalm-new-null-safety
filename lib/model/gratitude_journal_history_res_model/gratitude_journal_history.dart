class GratitudeJournalHistoryData {
  int? id;
  int? gratitudeJournalId;
  String? gratitudeQuestion;
  List<String?>? answer;
  String? date;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  int? createdBy;
  dynamic updatedBy;

  GratitudeJournalHistoryData({
    this.id,
    this.gratitudeJournalId,
    this.gratitudeQuestion,
    this.answer,
    this.date,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory GratitudeJournalHistoryData.fromJson(Map<String, dynamic> json) =>
      GratitudeJournalHistoryData(
        id: json['id'] as int?,
        gratitudeJournalId: json['gratitude_journal_id'] as int?,
        gratitudeQuestion: json['gratitude_question'] as String?,
        answer: json['answer'] != null
            ? List.generate((json['answer'] as String).split(";").length, (i) {
                return (json['answer'] as String).split(";")[i];
              })
            : null,
        date: json['date'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        publishedAt: json['published_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gratitude_journal_id': gratitudeJournalId,
        'gratitude_question': gratitudeQuestion,
        'answer': answer,
        'date': date,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'published_at': publishedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
