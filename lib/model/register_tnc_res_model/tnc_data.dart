class TncData {
  int? id;
  int? category;
  String? description;
  String? name;
  String? file;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic createdBy;
  int? updatedBy;

  TncData({
    this.id,
    this.category,
    this.description,
    this.name,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory TncData.fromJson(Map<String, dynamic> json) => TncData(
        id: json['id'] as int?,
        category: json['category'] as int?,
        description: json['description'] as String?,
        name: json['name'] as String?,
        file: json['file'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as dynamic,
        updatedBy: json['updated_by'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'description': description,
        'name': name,
        'file': file,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
