import 'pending_data.dart';

class PendingPaymentResModel {
  int? status;
  String? message;
  PendingData? pendingData;

  PendingPaymentResModel({this.status, this.message, this.pendingData});

  factory PendingPaymentResModel.fromJson(Map<String, dynamic> json) {
    return PendingPaymentResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      pendingData: json['data'] == null
          ? null
          : PendingData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': pendingData?.toJson(),
      };
}
