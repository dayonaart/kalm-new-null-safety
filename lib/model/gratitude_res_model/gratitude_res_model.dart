import 'gratitude_data.dart';

class GratitudeResModel {
  int? status;
  String? message;
  List<GratitudeData>? gratitudeData;

  GratitudeResModel({this.status, this.message, this.gratitudeData});

  factory GratitudeResModel.fromJson(Map<String, dynamic> json) {
    return GratitudeResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      gratitudeData: (json['data'] as List<dynamic>?)
          ?.map((e) => GratitudeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': gratitudeData?.map((e) => e.toJson()).toList(),
      };
}
