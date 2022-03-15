class UserNotificationSetting {
  int? counselorFeatured;
  int? counselorFeaturedOrder;
  String? subscriptionStartAt;
  String? subscriptionExpiredAt;
  String? language;
  int? emailClientSendMessage;
  int? emailRemindMyScheduled;
  int? emailClientWriteReview;
  int? notificationClientSendMessage;
  int? notificationRemindMyScheduled;
  int? notificationClientWriteReview;
  String? createdAt;
  String? updatedAt;
  int? subscriptionPercentage;

  UserNotificationSetting({
    this.counselorFeatured,
    this.counselorFeaturedOrder,
    this.subscriptionStartAt,
    this.subscriptionExpiredAt,
    this.language,
    this.emailClientSendMessage,
    this.emailRemindMyScheduled,
    this.emailClientWriteReview,
    this.notificationClientSendMessage,
    this.notificationRemindMyScheduled,
    this.notificationClientWriteReview,
    this.createdAt,
    this.updatedAt,
    this.subscriptionPercentage,
  });

  factory UserNotificationSetting.fromJson(Map<String, dynamic> json) {
    return UserNotificationSetting(
      counselorFeatured: json['counselor_featured'] as int?,
      counselorFeaturedOrder: json['counselor_featured_order'] as int?,
      subscriptionStartAt: json['subscription_start_at'] as String?,
      subscriptionExpiredAt: json['subscription_expired_at'] as String?,
      language: json['language'] as String?,
      emailClientSendMessage: json['email_client_send_message'] as int?,
      emailRemindMyScheduled: json['email_remind_my_scheduled'] as int?,
      emailClientWriteReview: json['email_client_write_review'] as int?,
      notificationClientSendMessage:
          json['notification_client_send_message'] as int?,
      notificationRemindMyScheduled:
          json['notification_remind_my_scheduled'] as int?,
      notificationClientWriteReview:
          json['notification_client_write_review'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      subscriptionPercentage: json['subscription_percentage'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'counselor_featured': counselorFeatured,
        'counselor_featured_order': counselorFeaturedOrder,
        'subscription_start_at': subscriptionStartAt,
        'subscription_expired_at': subscriptionExpiredAt,
        'language': language,
        'email_client_send_message': emailClientSendMessage,
        'email_remind_my_scheduled': emailRemindMyScheduled,
        'email_client_write_review': emailClientWriteReview,
        'notification_client_send_message': notificationClientSendMessage,
        'notification_remind_my_scheduled': notificationRemindMyScheduled,
        'notification_client_write_review': notificationClientWriteReview,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'subscription_percentage': subscriptionPercentage,
      };
}
