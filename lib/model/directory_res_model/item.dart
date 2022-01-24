import 'directory_category.dart';

class Item {
  String? phone2;
  String? email;
  int? id;
  int? categoryId;
  String? name;
  String? address;
  String? region;
  String? phone;
  String? url;
  String? category;
  int? status;
  DirectoryCategory? directoryCategory;

  Item({
    this.phone2,
    this.email,
    this.id,
    this.categoryId,
    this.name,
    this.address,
    this.region,
    this.phone,
    this.url,
    this.category,
    this.status,
    this.directoryCategory,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        phone2: json['phone2'] as String?,
        email: json['email'] as String?,
        id: json['id'] as int?,
        categoryId: json['category_id'] as int?,
        name: json['name'] as String?,
        address: json['address'] as String?,
        region: json['region'] as String?,
        phone: json['phone'] as String?,
        url: json['url'] as String?,
        category: json['category'] as String?,
        status: json['status'] as int?,
        directoryCategory: json['directory_category'] == null
            ? null
            : DirectoryCategory.fromJson(
                json['directory_category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'phone2': phone2,
        'email': email,
        'id': id,
        'category_id': categoryId,
        'name': name,
        'address': address,
        'region': region,
        'phone': phone,
        'url': url,
        'category': category,
        'status': status,
        'directory_category': directoryCategory?.toJson(),
      };
}
