class UserHasActiveCounselor {
  int? id;
  int? isReadTnc;
  int? isReadTncUpdate;
  int? isUniqueCode;
  int? userSubscriptionId;
  int? userId;
  int? counselorId;
  dynamic userReadTncAt;
  dynamic userReadTncUpdateAt;
  String? counselorConfirmedAt;
  dynamic forceConfimedAt;
  dynamic forceConfirmedBy;
  int? status;
  String? changeStatusAt;
  String? matchupAt;
  String? matchupAvailableAt;
  dynamic agreementToken;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic createdBy;
  int? updatedBy;

  UserHasActiveCounselor({
    this.id,
    this.isReadTnc,
    this.isReadTncUpdate,
    this.isUniqueCode,
    this.userSubscriptionId,
    this.userId,
    this.counselorId,
    this.userReadTncAt,
    this.userReadTncUpdateAt,
    this.counselorConfirmedAt,
    this.forceConfimedAt,
    this.forceConfirmedBy,
    this.status,
    this.changeStatusAt,
    this.matchupAt,
    this.matchupAvailableAt,
    this.agreementToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory UserHasActiveCounselor.fromJson(Map<String, dynamic> json) {
    return UserHasActiveCounselor(
      id: json['id'] as int?,
      isReadTnc: json['is_read_tnc'] as int?,
      isReadTncUpdate: json['is_read_tnc_update'] as int?,
      isUniqueCode: json['is_unique_code'] as int?,
      userSubscriptionId: json['user_subscription_id'] as int?,
      userId: json['user_id'] as int?,
      counselorId: json['counselor_id'] as int?,
      userReadTncAt: json['user_read_tnc_at'] as dynamic,
      userReadTncUpdateAt: json['user_read_tnc_update_at'] as dynamic,
      counselorConfirmedAt: json['counselor_confirmed_at'] as String?,
      forceConfimedAt: json['force_confimed_at'] as dynamic,
      forceConfirmedBy: json['force_confirmed_by'] as dynamic,
      status: json['status'] as int?,
      changeStatusAt: json['change_status_at'] as String?,
      matchupAt: json['matchup_at'] as String?,
      matchupAvailableAt: json['matchup_available_at'] as String?,
      agreementToken: json['agreement_token'] as dynamic,
      deletedAt: json['deleted_at'] as dynamic,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] as dynamic,
      updatedBy: json['updated_by'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_read_tnc': isReadTnc,
        'is_read_tnc_update': isReadTncUpdate,
        'is_unique_code': isUniqueCode,
        'user_subscription_id': userSubscriptionId,
        'user_id': userId,
        'counselor_id': counselorId,
        'user_read_tnc_at': userReadTncAt,
        'user_read_tnc_update_at': userReadTncUpdateAt,
        'counselor_confirmed_at': counselorConfirmedAt,
        'force_confimed_at': forceConfimedAt,
        'force_confirmed_by': forceConfirmedBy,
        'status': status,
        'change_status_at': changeStatusAt,
        'matchup_at': matchupAt,
        'matchup_available_at': matchupAvailableAt,
        'agreement_token': agreementToken,
        'deleted_at': deletedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
}
