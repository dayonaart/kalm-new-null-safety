class GratitudeData {
  int? id;
  String? question;
  dynamic description;
  String? startDate;
  String? endDate;
  int? status;
  int? order;
  String? createdAt;
  dynamic updatedAt;
  int? createdBy;
  dynamic updatedBy;
  List<String?>? response;

  GratitudeData({
    this.id,
    this.question,
    this.description,
    this.startDate,
    this.endDate,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.response,
  });

  factory GratitudeData.fromJson(Map<String, dynamic> json) => GratitudeData(
        id: json['id'] as int?,
        question: json['question'] as String?,
        description: json['description'] as dynamic,
        startDate: json['start_date'] as String?,
        endDate: json['end_date'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as dynamic,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as dynamic,
        response: json['response'] != null
            ? List.generate((json['response'] as String).split(";").length,
                (i) {
                return (json['response'] as String).split(";")[i];
              })
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'order': order,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'response': response,
      };
}
