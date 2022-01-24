import 'promo_data.dart';

class PromoResModel {
  int? status;
  String? message;
  PromoData? promoData;

  PromoResModel({this.status, this.message, this.promoData});

  factory PromoResModel.fromJson(Map<String, dynamic> json) => PromoResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        promoData: json['data'] == null
            ? null
            : PromoData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': promoData?.toJson(),
      };
}
