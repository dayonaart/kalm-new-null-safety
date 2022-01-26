import 'voucher_data.dart';

class VoucherResModel {
  int? status;
  String? message;
  VoucherData? voucherData;

  VoucherResModel({this.status, this.message, this.voucherData});

  factory VoucherResModel.fromJson(Map<String, dynamic> json) {
    return VoucherResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      voucherData: json['data'] == null
          ? null
          : VoucherData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': voucherData?.toJson(),
      };
}
