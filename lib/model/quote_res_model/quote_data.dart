import 'package:collection/collection.dart';

class Data {
  int? id;
  String? name;
  String? description;
  String? image;
  String? startDate;
  String? endDate;
  String? userRole;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  Data({
    this.id,
    this.name,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.userRole,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        startDate: json['start_date'] as String?,
        endDate: json['end_date'] as String?,
        userRole: json['user_role'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'start_date': startDate,
        'end_date': endDate,
        'user_role': userRole,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };

  Data copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? startDate,
    String? endDate,
    String? userRole,
    int? status,
    String? createdAt,
    String? updatedAt,
    int? createdBy,
    int? updatedBy,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      userRole: userRole ?? this.userRole,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Data) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      userRole.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode;
}
