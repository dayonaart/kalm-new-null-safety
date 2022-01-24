import 'contact_us_data.dart';

class ContactUsResModel {
  int? status;
  String? message;
  ContactUsData? contactUsData;

  ContactUsResModel({this.status, this.message, this.contactUsData});

  factory ContactUsResModel.fromJson(Map<String, dynamic> json) {
    return ContactUsResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      contactUsData: json['data'] == null
          ? null
          : ContactUsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': contactUsData?.toJson(),
      };
}
