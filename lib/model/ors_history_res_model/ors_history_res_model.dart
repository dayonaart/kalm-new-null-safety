import 'ors_data.dart';

class OrsHistoryResModel {
  int? status;
  String? message;
  List<OrsHistoryData>? orsData;

  OrsHistoryResModel({this.status, this.message, this.orsData});

  factory OrsHistoryResModel.fromJson(Map<String, dynamic> json) {
    return OrsHistoryResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      orsData: (json['data'] as List<dynamic>?)
          ?.map((e) => OrsHistoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': orsData?.map((e) => e.toJson()).toList(),
      };
}
