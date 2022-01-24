import 'directory_data.dart';

class DirectoryResModel {
  int? status;
  String? message;
  List<DirectoryData>? directoryData;

  DirectoryResModel({this.status, this.message, this.directoryData});

  factory DirectoryResModel.fromJson(Map<String, dynamic> json) {
    return DirectoryResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      directoryData: (json['data'] as List<dynamic>?)
          ?.map((e) => DirectoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': directoryData?.map((e) => e.toJson()).toList(),
      };
}
