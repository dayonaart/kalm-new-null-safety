class SubscriptionPayload {
  int? subscriptionId;
  String? promoCode;

  SubscriptionPayload({this.subscriptionId, this.promoCode});

  factory SubscriptionPayload.fromJson(Map<String, dynamic> json) {
    return SubscriptionPayload(
      subscriptionId: json['subscription_id'] as int?,
      promoCode: json['promo_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'subscription_id': subscriptionId,
        'promo_code': promoCode,
      };
}
