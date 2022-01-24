import 'questioner_data.dart';

class UserQuetionerResModel {
  int? status;
  String? message;
  List<QuestionerData>? questionerData;

  UserQuetionerResModel({this.status, this.message, this.questionerData});

  factory UserQuetionerResModel.fromJson(Map<String, dynamic> json) {
    return UserQuetionerResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      questionerData: (json['data'] as List<dynamic>?)
          ?.map((e) => QuestionerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': questionerData?.map((e) => e.toJson()).toList(),
      };
}
