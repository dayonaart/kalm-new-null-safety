import 'dart:convert';

class Subscription {
  int? id;
  dynamic isTrial;
  String? name;
  int? value;
  int? valueInDay;
  int? price;
  List<dynamic>? note;
  int? order;
  int? status;
  String? createdAt;
  String? updatedAt;

  Subscription({
    this.id,
    this.isTrial,
    this.name,
    this.value,
    this.valueInDay,
    this.price,
    this.note,
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'] as int?,
        isTrial: json['is_trial'] as dynamic,
        name: json['name'] as String?,
        value: json['value'] as int?,
        valueInDay: json['value_in_day'] as int?,
        price: json['price'] as int?,
        note: jsonDecode(json['note']) as List<dynamic>?,
        order: json['order'] as int?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_trial': isTrial,
        'name': name,
        'value': value,
        'value_in_day': valueInDay,
        'price': price,
        'note': note,
        'order': order,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
