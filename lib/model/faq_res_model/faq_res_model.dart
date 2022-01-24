import 'faq_data.dart';

class FaqResModel {
  int? status;
  String? message;
  List<FaqData>? faqData;

  FaqResModel({this.status, this.message, this.faqData});

  factory FaqResModel.fromJson(Map<String, dynamic> json) => FaqResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        faqData: (json['data'] as List<dynamic>?)
            ?.map((e) => FaqData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': faqData?.map((e) => e.toJson()).toList(),
      };
}
