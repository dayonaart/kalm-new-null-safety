import 'payment_data.dart';

class PaymentListResModel {
  int? status;
  String? message;
  List<PaymentData>? paymentData;

  PaymentListResModel({this.status, this.message, this.paymentData});

  factory PaymentListResModel.fromJson(Map<String, dynamic> json) {
    return PaymentListResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      paymentData: (json['data'] as List<dynamic>?)
          ?.map((e) => PaymentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': paymentData?.map((e) => e.toJson()).toList(),
      };
}
