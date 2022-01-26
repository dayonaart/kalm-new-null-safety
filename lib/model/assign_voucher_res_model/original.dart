class Original {
  int? status;
  String? message;
  int? subscriptionId;
  String? packageName;
  String? packageEndAt;

  Original({
    this.status,
    this.message,
    this.subscriptionId,
    this.packageName,
    this.packageEndAt,
  });

  factory Original.fromJson(Map<String, dynamic> json) => Original(
        status: json['status'] as int?,
        message: json['message'] as String?,
        subscriptionId: json['subscription_id'] as int?,
        packageName: json['package_name'] as String?,
        packageEndAt: json['package_end_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'subscription_id': subscriptionId,
        'package_name': packageName,
        'package_end_at': packageEndAt,
      };
}
