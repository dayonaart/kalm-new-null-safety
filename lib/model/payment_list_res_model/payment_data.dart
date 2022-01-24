class PaymentData {
  int? id;
  String? name;
  String? description;
  int? status;
  int? order;
  String? createdAt;
  dynamic updatedAt;
  int? createdBy;
  dynamic updatedBy;

  PaymentData({
    this.id,
    this.name,
    this.description,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as dynamic,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
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
