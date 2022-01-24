class UserCounselorOptionalFile {
  int? id;
  String? name;
  String? file;
  String? status;
  int? isMandatory;

  UserCounselorOptionalFile({
    this.id,
    this.name,
    this.file,
    this.status,
    this.isMandatory,
  });

  factory UserCounselorOptionalFile.fromJson(Map<String, dynamic> json) {
    return UserCounselorOptionalFile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      file: json['file'] as String?,
      status: json['status'] as String?,
      isMandatory: json['is_mandatory'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'file': file,
        'status': status,
        'is_mandatory': isMandatory,
      };
}
