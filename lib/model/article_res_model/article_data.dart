class ArticleData {
  int? id;
  String? name;
  String? file;
  String? publishAt;
  int? isCounselor;
  String? description;
  int? isMain;
  int? isBlog;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  ArticleData({
    this.id,
    this.name,
    this.file,
    this.publishAt,
    this.isCounselor,
    this.description,
    this.isMain,
    this.isBlog,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) => ArticleData(
        id: json['id'] as int?,
        name: json['name'] as String?,
        file: json['file'] as String?,
        publishAt: json['publish_at'] as String?,
        isCounselor: json['is_counselor'] as int?,
        description: json['description'] as String?,
        isMain: json['is_main'] as int?,
        isBlog: json['is_blog'] as int?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'file': file,
        'publish_at': publishAt,
        'is_counselor': isCounselor,
        'description': description,
        'is_main': isMain,
        'is_blog': isBlog,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
