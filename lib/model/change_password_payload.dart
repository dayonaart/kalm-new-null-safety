class ChangePasswordPayload {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  ChangePasswordPayload({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  factory ChangePasswordPayload.fromJson(Map<String, dynamic> json) {
    return ChangePasswordPayload(
      currentPassword: json['current_password'] as String?,
      newPassword: json['new_password'] as String?,
      confirmPassword: json['confirm_password'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
}
