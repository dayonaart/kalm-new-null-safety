class UserSubcription {
  int? id;
  int? subscriptionId;
  int? userId;
  dynamic isTrial;
  String? name;
  int? status;
  dynamic type;
  String? startAt;
  String? endAt;
  String? lastExtendAt;
  dynamic voucherId;
  dynamic promoId;
  dynamic methodPayment;
  dynamic midtransResponse;
  dynamic otherResponse;
  int? flagUserReadTnc;
  String? createdAt;
  String? updatedAt;

  UserSubcription({
    this.id,
    this.subscriptionId,
    this.userId,
    this.isTrial,
    this.name,
    this.status,
    this.type,
    this.startAt,
    this.endAt,
    this.lastExtendAt,
    this.voucherId,
    this.promoId,
    this.methodPayment,
    this.midtransResponse,
    this.otherResponse,
    this.flagUserReadTnc,
    this.createdAt,
    this.updatedAt,
  });

  factory UserSubcription.fromJson(Map<String, dynamic> json) {
    return UserSubcription(
      id: json['id'] as int?,
      subscriptionId: json['subscription_id'] as int?,
      userId: json['user_id'] as int?,
      isTrial: json['is_trial'] as dynamic,
      name: json['name'] as String?,
      status: json['status'] as int?,
      type: json['type'] as dynamic,
      startAt: json['start_at'] as String?,
      endAt: json['end_at'] as String?,
      lastExtendAt: json['last_extend_at'] as String?,
      voucherId: json['voucher_id'] as dynamic,
      promoId: json['promo_id'] as dynamic,
      methodPayment: json['method_payment'] as dynamic,
      midtransResponse: json['midtrans_response'] as dynamic,
      otherResponse: json['other_response'] as dynamic,
      flagUserReadTnc: json['flag_user_read_tnc'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subscription_id': subscriptionId,
        'user_id': userId,
        'is_trial': isTrial,
        'name': name,
        'status': status,
        'type': type,
        'start_at': startAt,
        'end_at': endAt,
        'last_extend_at': lastExtendAt,
        'voucher_id': voucherId,
        'promo_id': promoId,
        'method_payment': methodPayment,
        'midtrans_response': midtransResponse,
        'other_response': otherResponse,
        'flag_user_read_tnc': flagUserReadTnc,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
