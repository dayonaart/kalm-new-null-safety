class DirectoryCategory {
  int? id;
  String? name;
  int? status;

  DirectoryCategory({this.id, this.name, this.status});

  factory DirectoryCategory.fromJson(Map<String, dynamic> json) {
    return DirectoryCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
      };
}
