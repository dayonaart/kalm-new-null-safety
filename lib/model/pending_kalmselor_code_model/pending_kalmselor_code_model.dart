import 'data.dart';

class PendingKalmselorCodeModel {
  int? status;
  String? message;
  PendingKalmselorCodeModelData? data;

  PendingKalmselorCodeModel({this.status, this.message, this.data});

  factory PendingKalmselorCodeModel.fromJson(Map<String, dynamic> json) {
    return PendingKalmselorCodeModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : PendingKalmselorCodeModelData.fromJson(
              json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
