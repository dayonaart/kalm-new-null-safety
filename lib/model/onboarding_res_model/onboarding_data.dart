class OnboardingData {
  int? id;
  int? role;
  String? name;
  String? description;
  String? file;
  int? status;
  int? order;
  String? createdAt;
  String? updatedAt;

  OnboardingData({
    this.id,
    this.role,
    this.name,
    this.description,
    this.file,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) => OnboardingData(
        id: json['id'] as int?,
        role: json['role'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        file: json['file'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'name': name,
        'description': description,
        'file': file,
        'status': status,
        'order': order,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
