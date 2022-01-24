import 'directory_data.dart';

class DirectoryPageResModel {
  int? status;
  String? message;
  DirectoryPage? data;

  DirectoryPageResModel({this.status, this.message, this.data});

  factory DirectoryPageResModel.fromJson(Map<String, dynamic> json) {
    return DirectoryPageResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : DirectoryPage.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
