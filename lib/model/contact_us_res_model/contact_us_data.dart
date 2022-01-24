class ContactUsData {
  int? id;
  int? category;
  String? name;
  String? description;
  dynamic file;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  ContactUsData({
    this.id,
    this.category,
    this.name,
    this.description,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory ContactUsData.fromJson(Map<String, dynamic> json) => ContactUsData(
        id: json['id'] as int?,
        category: json['category'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        file: json['file'] as dynamic,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'name': name,
        'description': description,
        'file': file,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
