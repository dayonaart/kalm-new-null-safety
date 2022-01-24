import 'tnc_data.dart';

class TncResModel {
  int? status;
  String? message;
  List<TncResModelData>? data;

  TncResModel({this.status, this.message, this.data});

  factory TncResModel.fromJson(Map<String, dynamic> json) => TncResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => TncResModelData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
