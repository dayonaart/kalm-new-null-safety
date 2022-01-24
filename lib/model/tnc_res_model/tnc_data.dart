class TncResModelData {
  int? id;
  int? userId;
  String? name;
  String? description;
  int? status;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  dynamic updatedBy;

  TncResModelData({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory TncResModelData.fromJson(Map<String, dynamic> json) =>
      TncResModelData(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'description': description,
        'status': status,
        'order': order,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
