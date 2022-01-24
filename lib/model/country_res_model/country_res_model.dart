import 'country_data.dart';

class CountryResModel {
  int? status;
  String? message;
  List<CountryData>? data;

  CountryResModel({this.status, this.message, this.data});

  factory CountryResModel.fromJson(Map<String, dynamic> json) {
    return CountryResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CountryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
