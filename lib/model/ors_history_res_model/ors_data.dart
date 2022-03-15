class OrsHistoryData {
  int? id;
  int? userId;
  String? date;
  List<int>? value;
  String? createdAt;
  String? updatedAt;

  OrsHistoryData({
    this.id,
    this.userId,
    this.date,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory OrsHistoryData.fromJson(Map<String, dynamic> json) => OrsHistoryData(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        date: json['date'] as String?,
        value: (json['value'] as List<dynamic>).map((e) => e as int).toList(),
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date,
        'value': value,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
