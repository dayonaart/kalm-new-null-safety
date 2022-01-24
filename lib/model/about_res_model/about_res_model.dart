import 'about_data.dart';

class AboutResModel {
  int? status;
  String? message;
  AboutData? aboutData;

  AboutResModel({this.status, this.message, this.aboutData});

  factory AboutResModel.fromJson(Map<String, dynamic> json) => AboutResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        aboutData: json['data'] == null
            ? null
            : AboutData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': aboutData?.toJson(),
      };
}
