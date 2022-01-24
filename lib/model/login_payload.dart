class LoginPayload {
  String? email;
  String? password;
  String? role;
  String? firebaseToken;
  String? installationId;
  int? deviceNumber;
  int? deviceType;

  LoginPayload({
    this.email,
    this.password,
    this.role,
    this.firebaseToken,
    this.installationId,
    this.deviceNumber,
    this.deviceType,
  });

  factory LoginPayload.fromJson(Map<String, dynamic> json) => LoginPayload(
        email: json['email'] as String?,
        password: json['password'] as String?,
        role: json['role'] as String?,
        firebaseToken: json['firebase_token'] as String?,
        installationId: json['installation_id'] as String?,
        deviceNumber: json['device_number'] as int?,
        deviceType: json['device_type'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
        'firebase_token': firebaseToken,
        'installation_id': installationId,
        'device_number': deviceNumber,
        'device_type': deviceType,
      };
}
