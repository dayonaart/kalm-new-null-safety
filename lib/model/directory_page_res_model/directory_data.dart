class DirectoryPage {
  int? id;
  int? category;
  String? description;
  String? name;
  String? file;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? updatedBy;

  DirectoryPage({
    this.id,
    this.category,
    this.description,
    this.name,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  factory DirectoryPage.fromJson(Map<String, dynamic> json) => DirectoryPage(
        id: json['id'] as int?,
        category: json['category'] as int?,
        description: json['description'] as String?,
        name: json['name'] as String?,
        file: json['file'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
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
        'updated_by': updatedBy,
      };
}
