import 'subscription_data.dart';

class SubscriptionListResModel {
  int? status;
  String? message;
  List<SubscriptionData>? subscriptionData;

  SubscriptionListResModel({
    this.status,
    this.message,
    this.subscriptionData,
  });

  factory SubscriptionListResModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionListResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      subscriptionData: (json['data'] as List<dynamic>?)
          ?.map((e) => SubscriptionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': subscriptionData?.map((e) => e.toJson()).toList(),
      };
}
