import 'onboarding_data.dart';

class OnboardingResModel {
  int? status;
  String? message;
  List<OnboardingData>? data;

  OnboardingResModel({this.status, this.message, this.data});

  factory OnboardingResModel.fromJson(Map<String, dynamic> json) {
    return OnboardingResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OnboardingData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
