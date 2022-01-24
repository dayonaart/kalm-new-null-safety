import 'tnc_data.dart';

class RegisterTncResModel {
  int? status;
  String? message;
  TncData? tncData;

  RegisterTncResModel({this.status, this.message, this.tncData});

  factory RegisterTncResModel.fromJson(Map<String, dynamic> json) {
    return RegisterTncResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      tncData: json['data'] == null
          ? null
          : TncData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': tncData?.toJson(),
      };
}
