class RegisterPayload {
  String? firstName;
  String? lastName;
  int? gender;
  String? email;
  String? password;
  String? confirmPassword;
  String? role;
  int? deviceNumber;
  int? deviceType;
  String? installationId;
  String? tempUserCode;
  String? uniqueCodeRequest;
  String? language;

  RegisterPayload({
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.password,
    this.confirmPassword,
    this.role,
    this.deviceNumber,
    this.deviceType,
    this.installationId,
    this.tempUserCode,
    this.uniqueCodeRequest,
    this.language,
  });

  factory RegisterPayload.fromJson(Map<String, dynamic> json) {
    return RegisterPayload(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as int?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      confirmPassword: json['confirm_password'] as String?,
      role: json['role'] as String?,
      deviceNumber: json['device_number'] as int?,
      deviceType: json['device_type'] as int?,
      installationId: json['installation_id'] as String?,
      tempUserCode: json['temp_user_code'] as String?,
      uniqueCodeRequest: json['unique_code_request'] as String?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'role': role,
        'device_number': deviceNumber,
        'device_type': deviceType,
        'installation_id': installationId,
        'temp_user_code': tempUserCode,
        'unique_code_request': uniqueCodeRequest,
        'language': language,
      };
}
