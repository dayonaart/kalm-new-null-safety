import 'dart:convert';

import 'package:kalm/model/payment_data_res_model/payment_data_res_model.dart';
import 'package:kalm/model/pending_payment_res_model/another_response_data.dart';

import 'package.dart';

class PendingData {
  int? id;
  int? subscriptionId;
  int? userId;
  dynamic isTrial;
  String? name;
  int? status;
  dynamic type;
  String? startAt;
  String? endAt;
  dynamic lastExtendAt;
  dynamic voucherId;
  dynamic promoId;
  dynamic methodPayment;
  dynamic midtransResponse;
  PaymentDataResModel? otherResponse;
  AnotherResponseData? anotherResponse;
  dynamic flagUserReadTnc;
  String? createdAt;
  String? updatedAt;
  Package? package;

  PendingData({
    this.id,
    this.subscriptionId,
    this.userId,
    this.isTrial,
    this.name,
    this.status,
    this.type,
    this.startAt,
    this.endAt,
    this.lastExtendAt,
    this.voucherId,
    this.promoId,
    this.methodPayment,
    this.midtransResponse,
    this.otherResponse,
    this.flagUserReadTnc,
    this.createdAt,
    this.updatedAt,
    this.package,
    this.anotherResponse,
  });

  factory PendingData.fromJson(Map<String, dynamic> json) => PendingData(
        id: json['id'] as int?,
        subscriptionId: json['subscription_id'] as int?,
        userId: json['user_id'] as int?,
        isTrial: json['is_trial'] as dynamic,
        name: json['name'] as String?,
        status: json['status'] as int?,
        type: json['type'] as dynamic,
        startAt: json['start_at'] as String?,
        endAt: json['end_at'] as String?,
        lastExtendAt: json['last_extend_at'] as dynamic,
        voucherId: json['voucher_id'] as dynamic,
        promoId: json['promo_id'] as dynamic,
        methodPayment: json['method_payment'] as dynamic,
        midtransResponse: json['midtrans_response'] as dynamic,
        otherResponse: json['other_response'] != null
            ? PaymentDataResModel.fromJson(jsonDecode(json['other_response']))
            : null,
        anotherResponse: json['other_response'] != null
            ? AnotherResponseData.fromJson(jsonDecode(json['other_response']))
            : null,
        flagUserReadTnc: json['flag_user_read_tnc'] as dynamic,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        package: json['package'] == null
            ? null
            : Package.fromJson(json['package'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'subscription_id': subscriptionId,
        'user_id': userId,
        'is_trial': isTrial,
        'name': name,
        'status': status,
        'type': type,
        'start_at': startAt,
        'end_at': endAt,
        'last_extend_at': lastExtendAt,
        'voucher_id': voucherId,
        'promo_id': promoId,
        'method_payment': methodPayment,
        'midtrans_response': midtransResponse,
        'other_response': otherResponse?.toJson(),
        'another_response': anotherResponse?.toJson(),
        'flag_user_read_tnc': flagUserReadTnc,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'package': package?.toJson(),
      };
}
