import 'dart:convert';

import 'description_child.dart';

class FaqData {
  int? id;
  int? category;
  String? name;
  int? status;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  List<DescriptionChild>? descriptionChild;
  String? description;

  FaqData({
    this.id,
    this.category,
    this.name,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.descriptionChild,
    this.description,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json['id'] as int?,
        category: json['category'] as int?,
        name: json['name'] as String?,
        status: json['status'] as int?,
        order: json['order'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        descriptionChild: (jsonDecode(json['description_child'])
                as List<dynamic>?)
            ?.map((e) => DescriptionChild.fromJson(e as Map<String, dynamic>))
            .toList(),
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'name': name,
        'status': status,
        'order': order,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'description_child': descriptionChild?.map((e) => e.toJson()).toList(),
        'description': description,
      };
}
