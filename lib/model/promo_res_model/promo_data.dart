import 'dart:convert';

import 'subscription.dart';

class PromoData {
  int? id;
  dynamic subscriptionIds;
  String? code;
  String? name;
  String? note;
  int? type;
  int? valueType;
  dynamic value;
  int? quota;
  String? startAt;
  String? endAt;
  int? status;
  String? createdAt;
  String? updatedAt;
  Subscription? subscription;
  int? finalAmount;

  PromoData({
    this.id,
    this.subscriptionIds,
    this.code,
    this.name,
    this.note,
    this.type,
    this.valueType,
    this.value,
    this.quota,
    this.startAt,
    this.endAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subscription,
    this.finalAmount,
  });

  factory PromoData.fromJson(Map<String, dynamic> json) => PromoData(
        id: json['id'] as int?,
        subscriptionIds: jsonEncode(json['subscription_ids']),
        code: json['code'] as String?,
        name: json['name'] as String?,
        note: json['note'] as String?,
        type: json['type'] as int?,
        valueType: json['value_type'] as int?,
        value: json['value'],
        quota: json['quota'] as int?,
        startAt: json['start_at'] as String?,
        endAt: json['end_at'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        subscription: json['subscription'] == null
            ? null
            : Subscription.fromJson(
                json['subscription'] as Map<String, dynamic>),
        finalAmount: json['final_amount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'subscription_ids': subscriptionIds,
        'code': code,
        'name': name,
        'note': note,
        'type': type,
        'value_type': valueType,
        'value': value,
        'quota': quota,
        'start_at': startAt,
        'end_at': endAt,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'subscription': subscription?.toJson(),
        'final_amount': finalAmount,
      };
}
