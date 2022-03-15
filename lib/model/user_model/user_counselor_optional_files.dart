class UserCounselorOptionalFiles {
  int? id;
  String? name;
  String? file;
  int? status;
  int? isMandatory;
  String? createdAt;
  String? updatedAt;
  dynamic createdBy;
  dynamic updatedBy;

  UserCounselorOptionalFiles({
    this.id,
    this.name,
    this.file,
    this.status,
    this.isMandatory,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory UserCounselorOptionalFiles.fromJson(Map<String, dynamic> json) {
    return UserCounselorOptionalFiles(
      id: json['id'] as int?,
      name: json['name'] as String?,
      file: json['file'] as String?,
      status: json['status'] as int?,
      isMandatory: json['is_mandatory'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as dynamic,
      updatedBy: json['updated_by'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'file': file,
        'status': status,
        'is_mandatory': isMandatory,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
