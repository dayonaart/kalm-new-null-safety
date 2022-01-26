class VoucherData {
  int? id;
  int? userVoucherGroupId;
  dynamic userId;
  int? subscriptionId;
  String? code;
  String? name;
  String? note;
  int? isCorporate;
  int? type;
  dynamic nameCorporate;
  String? startAt;
  String? endAt;
  int? status;
  String? createdAt;
  String? updatedAt;

  VoucherData({
    this.id,
    this.userVoucherGroupId,
    this.userId,
    this.subscriptionId,
    this.code,
    this.name,
    this.note,
    this.isCorporate,
    this.type,
    this.nameCorporate,
    this.startAt,
    this.endAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) => VoucherData(
        id: json['id'] as int?,
        userVoucherGroupId: json['user_voucher_group_id'] as int?,
        userId: json['user_id'] as dynamic,
        subscriptionId: json['subscription_id'] as int?,
        code: json['code'] as String?,
        name: json['name'] as String?,
        note: json['note'] as String?,
        isCorporate: json['is_corporate'] as int?,
        type: json['type'] as int?,
        nameCorporate: json['name_corporate'] as dynamic,
        startAt: json['start_at'] as String?,
        endAt: json['end_at'] as String?,
        status: json['status'] as int?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_voucher_group_id': userVoucherGroupId,
        'user_id': userId,
        'subscription_id': subscriptionId,
        'code': code,
        'name': name,
        'note': note,
        'is_corporate': isCorporate,
        'type': type,
        'name_corporate': nameCorporate,
        'start_at': startAt,
        'end_at': endAt,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
