import 'assign_voucher_data.dart';

class AssignVoucherResModel {
  int? status;
  String? message;
  AssignVoucherData? assignVoucherData;

  AssignVoucherResModel({this.status, this.message, this.assignVoucherData});

  factory AssignVoucherResModel.fromJson(Map<String, dynamic> json) {
    return AssignVoucherResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      assignVoucherData: json['data'] == null
          ? null
          : AssignVoucherData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': assignVoucherData?.toJson(),
      };
}
