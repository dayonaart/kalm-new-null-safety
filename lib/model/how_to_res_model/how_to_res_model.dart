import 'how_to_data.dart';

class HowToResModel {
  int? status;
  String? message;
  HowToData? howToData;

  HowToResModel({this.status, this.message, this.howToData});

  factory HowToResModel.fromJson(Map<String, dynamic> json) => HowToResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        howToData: json['data'] == null
            ? null
            : HowToData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': howToData?.toJson(),
      };
}
