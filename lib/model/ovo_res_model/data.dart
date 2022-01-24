class OvoResData {
  int? amount;
  String? businessId;
  String? created;
  String? ewalletType;
  String? externalId;
  String? phone;
  String? status;

  OvoResData({
    this.amount,
    this.businessId,
    this.created,
    this.ewalletType,
    this.externalId,
    this.phone,
    this.status,
  });

  factory OvoResData.fromJson(Map<String, dynamic> json) => OvoResData(
        amount: json['amount'].runtimeType == String
            ? int.parse(json['amount'])
            : (json['amount'] as int?),
        businessId: json['business_id'] as String?,
        created: json['created'] as String?,
        ewalletType: json['ewallet_type'] as String?,
        externalId: json['external_id'] as String?,
        phone: json['phone'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'business_id': businessId,
        'created': created,
        'ewallet_type': ewalletType,
        'external_id': externalId,
        'phone': phone,
        'status': status,
      };
}
